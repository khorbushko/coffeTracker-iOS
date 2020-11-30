//
//  EnvironmentValues.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 11/30/20.
//

import Foundation
import SwiftUI

private struct HealthKitManagerKey: EnvironmentKey {
    static var defaultValue: HealthKitService = HealthKitManager()
}

extension EnvironmentValues {
    var healthKitService: HealthKitService {
        get { self[HealthKitManagerKey.self] }
        set { self[HealthKitManagerKey.self] = newValue }
    }
}
