//
//  View+VibroEffect.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/15/21.
//

import Foundation
import UIKit
import SwiftUI
import AudioToolbox

enum VibroEffect {
    
    case success
    case warning
    case error
    case selection
}

extension View {
    
    func executeVibroEffect(_ effect: VibroEffect) {
        switch effect {
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}
