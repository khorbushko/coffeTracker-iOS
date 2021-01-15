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
    
    private let healthKitService: HealthKitService
    private var tokens: Set<AnyCancellable> = []
    
    init(_ healthKitService: HealthKitService) {
        self.healthKitService = healthKitService
    }
    
    // MARK: - Public
    
    func requestDrinks() {
        drinks = CDDrink.fetchAllFavourites()?
            .compactMap({ $0.coffeeDrink() }) ?? []
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
                } else {
                    self?.state = .failed(StoreState.Failure.cantStoreObject)
                }
                                
                print("stored \(success)")
            }
            .store(in: &tokens)
    }
}
