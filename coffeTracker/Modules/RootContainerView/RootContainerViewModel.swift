//
//  RootContainerViewModel.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 12/11/20.
//

import Foundation
import Combine

final class RootContainerViewModel: ObservableObject {
    
    @Published var shouldAskPermission: Bool = false
    private let healthStore: HealthKitService
    private var subscriptions = Set<AnyCancellable>()
    
    init(healthStore: HealthKitService) {
        self.healthStore = healthStore
        
        configureSubscription()
    }
    
    private func configureSubscription() {
        healthStore.shouldAskDataAccess()
            .sink { (value) in
                self.shouldAskPermission = value
            }
            .store(in: &subscriptions)
    }
}
