//
//  HomeViewModel.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/8/21.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    enum StoreState: Equatable {
        enum Failure: Error {
            case cantConvertObject
            case cantStoreObject
        }
        
        case inactive
        case storing
        case stored
        case failed(Error)
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.inactive, .inactive),
                 (.storing, .storing),
                 (.stored, .stored):
                return true
            case (.failed(let lhsError), .failed(let rhsError)):
                if let lhsError = lhsError as? Failure,
                   let rhsError = rhsError as? Failure {
                    return lhsError == rhsError
                } else {
                    return false
                }
            default:
                return false
            }
        }
    }
    
    @Published private(set) var state: StoreState = .inactive
    @Published private(set) var drinks: [CoffeeContainableDrink] = []
    @Published private(set) var consumedCoffeine: Double = 0
    @Published private(set) var activeCoffeine: Double = 0
    
    // last 24 day drink hour, caffeine amount, name
    @Published private(set) var consumedCoffeineData: [(Double, Double, String)] = []
    
    // last 24 day drink hour, active caffeine amount, name
    @Published private(set) var consumedActiveCoffeineData: [(Double, Double, String)] = []
    
    private let healthKitService: HealthKitService
    private var tokens: Set<AnyCancellable> = []
    
    init(_ healthKitService: HealthKitService) {
        self.healthKitService = healthKitService
    }
    
    // MARK: - Public
    
    func fetchTodaysDrink() {
        
        tokens.removeAll() // ??
        
        healthKitService.fetchLast24HCaffeineConsumptionData()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                
            } receiveValue: { (values) in
                self.consumedCoffeine = values
                    .map({ $0.caffeine })
                    .reduce(0, +)
                self.activeCoffeine = values
                    .map({ $0.remainingCaffeine })
                    .reduce(0, +)
            }
            .store(in: &tokens)
    }
    
    func requestDrinks() {
        drinks = CDDrink.fetchAllFavourites()?
            .compactMap({ $0.coffeeDrink() })
            .sorted(by: {
                $0.displayOrder < $1.displayOrder
            })
            ?? []
    }

    func indexFor(_ drink: CoffeeContainableDrink) -> Int? {
        drinks
            .firstIndex(where: { drink.uuid == $0.uuid })
    }
    
    func saveDrink(_ drink: CoffeeContainableDrink) {
        state = .inactive
        state = .storing
        
        healthKitService.saveDrink(drink)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.state = .failed(error)
                default:
                    break /*do nothing*/
                }
            } receiveValue: { [weak self] (success) in
                if success {
                    self?.state = .stored
                    self?.fetchTodaysDrink()
                } else {
                    self?.state = .failed(StoreState.Failure.cantStoreObject)
                }
                    
                debugPrint("stored \(success)")
            }
            .store(in: &tokens)
    }
}
