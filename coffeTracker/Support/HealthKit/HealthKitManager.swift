//
//  HealthKitManager.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 11/30/20.
//

import Foundation
import Combine
import HealthKit

enum Health {
    enum AccessState: CaseIterable {
        case proceed
        case failed
        case unavailable
        case undefined
    }
}

protocol HealthKitService {
    
    func shouldAskDataAccess() -> AnyPublisher<Bool, Never>
    func requestDataAccess() -> AnyPublisher<Health.AccessState, Never>
    
    func saveDrink(_ drink: CoffeeContainableDrink) -> AnyPublisher<Bool, Error>
    
    func fetchLast24HCaffeineConsumptionData() -> AnyPublisher<[ConsumedCaffeine], Error>
}

final class HealthKitManager: HealthKitService {
    
    enum StoreFailure: Error {
        
        case storageNotAvailable
        case objectTypeNotAvailable
    }
    
    private let healthStore = HKHealthStore()
    private lazy var isAvailable = HKHealthStore.isHealthDataAvailable()
    
    private lazy var milligrams = HKUnit.gramUnit(with: .milli)
    private lazy var caffeineType = HKObjectType.quantityType(forIdentifier: .dietaryCaffeine)
    private lazy var calories = HKUnit.smallCalorie()
    private lazy var caloriesType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)

    private var writeTypes: Set<HKQuantityType> {
        Set(
            [
                HKObjectType.quantityType(forIdentifier: .dietaryCaffeine),
                HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)
            ]
            .compactMap({ $0 })
        )
    }
    
    private var readTypes: Set<HKQuantityType> {
        Set(
            [
                HKObjectType.quantityType(forIdentifier: .bodyMass),
                HKObjectType.quantityType(forIdentifier: .height),
                HKObjectType.quantityType(forIdentifier: .dietaryCaffeine),
                HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)
            ]
            .compactMap({ $0 })
        )
    }
    
    // MARK: - Access
    
    func shouldAskDataAccess() -> AnyPublisher<Bool, Never> {
        Deferred {
            Future { promise in
                self.healthStore.getRequestStatusForAuthorization(
                    toShare: self.writeTypes,
                    read: self.readTypes) { (status, error) in
                    switch status {
                    case .unknown,
                         .shouldRequest:
                        promise(.success(true))
                    case .unnecessary:
                        promise(.success(false))
                    @unknown default:
                        promise(.success(false))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func requestDataAccess() -> AnyPublisher<Health.AccessState, Never> {
        Deferred {
            Future { promise in
                self.healthStore.requestAuthorization(
                    toShare: self.writeTypes,
                    read: self.readTypes
                ) { (success, error) in
                    if success {
                        promise(.success(.proceed))
                    } else {
                        promise(.success(.failed))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Save drink
        
    func saveDrink(_ drink: CoffeeContainableDrink) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { promise in
                if !self.isAvailable  {
                    promise(.failure(StoreFailure.storageNotAvailable))
                }
                
                if let caffeineType = self.caffeineType,
                   let caloriesType = self.caloriesType {
                    let metadata: [String: Any] = [
                        HKMetadataKeySyncIdentifier: UUID().uuidString,
                        HKMetadataKeySyncVersion: 1,
                        HKMetadataKeyTimeZone: TimeZone.current.identifier,
                        HKMetadataKeyWasUserEntered: NSNumber(booleanLiteral: false),
                        HKMetadataKeyFoodType: drink.name
                    ]
                    
                    let start = Date()
                    let end = start
                    
                    let mgCaffeine = HKQuantity(unit: self.milligrams, doubleValue: drink.caffeine)
                    let caffeineSample = HKQuantitySample(
                        type: caffeineType,
                        quantity: mgCaffeine,
                        start: start,
                        end: end,
                        metadata: metadata
                    )
                    
                    let caloriesQty = HKQuantity(unit: self.calories, doubleValue: drink.calories)
                    let caloriesSample = HKQuantitySample(
                        type: caloriesType,
                        quantity: caloriesQty,
                        start: start,
                        end: end,
                        metadata: metadata
                    )
                    
                    self.healthStore.save([
                        caffeineSample,
                        caloriesSample
                    ]
                    ) { (success, error) in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            assert(success, "no error should indicate success")
                            promise(.success(success))
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch
    
    func fetchLast24HCaffeineConsumptionData() -> AnyPublisher<[ConsumedCaffeine], Error> {
        Deferred {
            Future { promise in
                
                // Create a predicate that only returns samples created within the last 24 hours
                let endDate = Date()
                let startDate = endDate.addingTimeInterval(-24.0 * 60.0 * 60.0)
                let datePredicate = HKQuery.predicateForSamples(
                    withStart: startDate,
                    end: endDate,
                    options:
                        [
                            .strictStartDate,
                            .strictEndDate
                        ]
                )
                
                if let caffeineType = self.caffeineType {
                    let query = HKSampleQuery(
                        sampleType: caffeineType,
                        predicate: datePredicate,
                        limit: HKObjectQueryNoLimit,
                        sortDescriptors: nil,
                        resultsHandler: { (query, samples, error) in
                            
                            if let error = error {
                                promise(.failure(error))
                                return
                            }
                                                        
                            let consumedCoffenineRecords: [ConsumedCaffeine] = samples?
                                .compactMap({ $0 as? HKQuantitySample })
                                .compactMap({
                                    ConsumedCaffeine.from(sample: $0, unit: self.milligrams)
                                })
                                ?? []
                            promise(.success(consumedCoffenineRecords))

                        })
                    
                    self.healthStore.execute(query)
                    
                } else {
                    promise(.failure(StoreFailure.objectTypeNotAvailable))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

fileprivate extension ConsumedCaffeine {
    
    static func from(sample: HKQuantitySample, unit: HKUnit) -> ConsumedCaffeine {
        let caffeineMg = sample.quantity.doubleValue(for: unit)
        let drinkDate = sample.startDate
        let uuid = sample.metadata?[HKMetadataKeySyncIdentifier] as? String ?? sample.uuid.uuidString
        let drinkName = sample.metadata?[HKMetadataKeyFoodType] as? String
        
        let consumedCoffenine = ConsumedCaffeine(
            caffeine: caffeineMg,
            unit: "mg",
            uuid: uuid,
            drinkDate: drinkDate,
            sourceName: drinkName
        )
        
        return consumedCoffenine
    }
}

/**
 information related to coffe
 
 Black coffee contains a number of micronutrients, notably potassium, magnesium and niacin. The sodium level is very low. The data below provides the micronutrient nutritional profile of 100ml of medium strength black coffee34.
 
 dietarySodium      - 0 mg
 dietaryPotassium   - 92 mg
 dietaryMagnesium   - 8 mg
 dietaryManganese   - 0.05 mg
 dietaryRiboflavin  - 0.01 mg
 dietaryNiacin      - 0.7 mg
 dietaryCaffeine    - 63 mg
 dietaryEnergyConsumed -  1-2 kcal
 
 1.oz = 29.5735296875 ml
 
 Brewed Coffee
 made by pouring hot or boiling water over ground coffee beans, usually contained in a filter
 
 8 oz
 dietaryCaffeine    - 95 mg
 
 Espresso
 made by forcing a small amount of hot water, or steam, through finely ground coffee beans.
 1 - 1.75 oz
 dietaryCaffeine    - 63 mg
 
 Espresso-Based Drinks
 made from espresso shots mixed with varying types and amounts of milk.
 various oz
 
 small
 dietaryCaffeine    - 63 mg
 large
 dietaryCaffeine    - 125 mg
 
 Instant Coffee
 made from brewed coffee that has been freeze-dried or spray-dried. It is generally in large, dry pieces, which dissolve in water
 ?
 dietaryCaffeine    - 50 mg
 
 Decaf Coffee
 decaf coffee is not entirely caffeine free
 
 dietaryCaffeine    - 3 mg
 
 
 
 Coffee drinks    Size in oz. (mL)    Caffeine (mg)
 Brewed              8 (237)            96
 Brewed, decaf       8 (237)             2
 Espresso            1 (30)              64
 Espresso, decaf     1 (30)              0
 Instant             8 (237)            62
 Instant, decaf      8 (237)             2
 
 
 Teas                   Size in oz. (mL)    Caffeine (mg)
 Brewed black                8 (237)             47
 Brewed black, decaf         8 (237)              2
 Brewed green               8 (237)             28
 Ready-to-drink, bottled    8 (237)              19
 
 Sodas                   Size in oz. (mL)        Caffeine (mg)
 Citrus (most brands)            8 (237)               0
 Cola                            8 (237)                22
 Root beer (most brands)         8 (237)                  0
 
 
 
 Energy drinks           Size in oz. (mL)    Caffeine (mg)
 Energy drink                8 (237)             29
 Energy shot                 1 (30)               215
 
 ----
 
 Drink type          Caffeine content [g/L]    Standard size             Caffeine dose
 in a portion [mg]
 Espresso                   1.5                 1.7 fl oz (50 ml)            75
 Filter coffee               0.6                8 fl oz (237 ml)             142.2
 Instant coffee              0.4                8 fl oz (237 ml)                94.8
 Latte / Mocha               0.34               8 fl oz (237 ml)             80.58
 Decaf                       0.04                8 fl oz (237 ml)                9.48
 Covfefe 🤯                  3                  1 wall (2000 miles)
 Black tea                  0.15                8 fl oz (237 ml)                35.55
 Green tea                  0.09                 8 fl oz (237 ml)                21.33
 Yerba mate                 0.3                 8 fl oz (237 ml)                71.1
 Energy drink               0.33                8.6 fl oz (250 ml)               82.5
 Yerba mate drink            0.2                 17 fl oz (500 ml)               100
 Energy shot                3.3                  1.7 fl oz (50 ml)                165
 Coke                       0.1                 12 fl oz (355 ml)                35.5
 Diet Coke                  0.13                12 fl oz (355 ml)                46.15
 
 -----
 
 effects depend upon the dosage and on personal factors, including age, body weight, and how sensitive a person is to caffeine
 
 Most adults can safely consume 200–300 mg per day
 5h - semidismiss time
 
 
 safe dosage:
 
 adult
 400 mg per 76 kg or 5.26 mg of caffeine per kilogram of body weight is considered safe caffeine intake for an average adult
 400 mg per day (1 kg - 6 mg)
 for pregnant - 4.31 mg / kg
 
 
 Ages 13-18
 100 mg per day
 2.5 mg per kg of body weight
 
 
 
 */

