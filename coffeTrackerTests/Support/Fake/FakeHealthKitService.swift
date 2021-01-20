//
//  FakeHealthKitService.swift
//  coffeTrackerTests
//
//  Created by Kyryl Horbushko on 12/12/20.
//

import Foundation
import Combine

@testable import coffeTracker

final class FakeHealthKitService: HealthKitService {
    func saveDrink(_ drink: CoffeeContainableDrink) -> AnyPublisher<Bool, Error> {
        fatalError()
    }
    
    func fetchLast24HCaffeineConsumptionData() -> AnyPublisher<[ConsumedCaffeine], Error> {
        fatalError()
    }
    
    
    var askDataAccessDone: Bool = true
    func shouldAskDataAccess() -> AnyPublisher<Bool, Never> {
        Deferred {
            Future { promice in
                promice(.success(self.askDataAccessDone))
            }
        }
        .eraseToAnyPublisher()
    }
    
    var requestResponse: Health.AccessState = .proceed
    var disableResponseForDataAccess: Bool = false
    func requestDataAccess() -> AnyPublisher<Health.AccessState, Never> {
        Deferred {
            Future { promice in
                if !self.disableResponseForDataAccess {
                    promice(.success(self.requestResponse))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
