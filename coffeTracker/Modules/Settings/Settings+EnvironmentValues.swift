//
//  Settings+EnvironmentValues.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/15/21.
//

import Foundation
import SwiftUI

private struct SettingsServiceKey: EnvironmentKey {
    static var defaultValue: SettingsService = UserDefaults.standard
}

extension EnvironmentValues {
    var settings: SettingsService {
        get { self[SettingsServiceKey.self] }
        set { self[SettingsServiceKey.self] = newValue }
    }
}
