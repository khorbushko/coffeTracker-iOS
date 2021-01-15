//
//  SettingsViewModel.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/15/21.
//

import Foundation
import Combine
import SwiftUI

@dynamicMemberLookup
final class SettingsViewModel: ObservableObject {
    subscript<T>(dynamicMember keyPath: WritableKeyPath<SettingsService, T>) -> T {
        get { storage[keyPath: keyPath] }
        set { storage[keyPath: keyPath] = newValue }
    }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    private let cancellable: Cancellable
    private var storage: SettingsService
    
    // MARK: - LifeCycle
    
    init(storage: SettingsService) {
        self.storage = storage
        
        cancellable = NotificationCenter.default
            .publisher(for: storage.didChange)
            .map { _ in () }
            .subscribe(objectWillChange)
    }
}
