//
//  UserDefaults+SettingsService.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/15/21.
//

import Foundation
import Combine

extension UserDefaults: SettingsService {
    private struct ValueStorage {
        
        @UserDefaultValue(SettingsDataKeys.isVibroEnabled, defaultValue: true)
        static var isVibroEnabled: Bool
    }
    
    var didChange: NSNotification.Name {
        get {
            UserDefaults.didChangeNotification
        }
    }
    
    var isVibroEnabled: Bool {
        set { ValueStorage.isVibroEnabled = newValue }
        get { ValueStorage.isVibroEnabled }
    }
    
    // MARK: - Private
    
    private func value<T>(forKey key: String) -> T? {
        value(forKey: key) as? T
    }
}
