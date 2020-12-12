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
