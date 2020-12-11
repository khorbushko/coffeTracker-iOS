//
//  IntroViewModel.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 11/30/20.
//

import Foundation
import SwiftUI
import Combine

final class IntroViewModel: ObservableObject {
    typealias PermissionRequested = Bool
        
    enum State: Equatable {
        case initial
        case requested
        case responseReceived(PermissionRequested)
        
        var isResponseReceived: Bool {
            self == .responseReceived(true) ||
                self == .responseReceived(false)
        }
    }
    
    enum Action {
        
        case next
    }
        
    @Published private(set) var state: State = .initial
    private let healthStore: HealthKitService
    private var subscription = Set<AnyCancellable>()
    
    // MARK: - LifeCycle
    
    init(healthStore: HealthKitService) {
        self.healthStore = healthStore
    }
    
    // MARK: - Public
    
    func perform(_ action: Action) {
        switch action {
        case .next:
            state = .requested
            requestAppleHealthPermissions()
        }
    }
    
    // MARK: - Private
    
    private func requestAppleHealthPermissions() {
        healthStore.requestDataAccess()
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] (state) in
                switch state {
                case .proceed:
                    self?.state = .responseReceived(true)
                case .failed:
                    self?.state = .responseReceived(false)
                default:
                    self?.state = .responseReceived(false)
                }
            }
            .store(in: &subscription)
    }
}
