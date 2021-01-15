//
//  View+Settings.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/15/21.
//

import Foundation
import SwiftUI

extension View {
    
    // MARK: - View+Settings
    
    func vibroOnTapIfNeeded(
        _ effect: VibroEffect,
        settings: SettingsService
    ) -> some View {
        simultaneousGesture(
            TapGesture()
                .onEnded({ _ in
                    if settings.isVibroEnabled {
                        executeVibroEffect(effect)
                    }
                })
        )
    }
}
