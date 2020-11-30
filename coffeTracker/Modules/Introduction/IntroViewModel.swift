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
    
    enum Action {
        
        case next
    }
    
    @Published private(set) var isNextButtonPressed: Bool = false
    
    func perform(_ action: Action) {
        switch action {
        case .next:
            isNextButtonPressed = true
        }
    }
}
