//
//  DelayedAnimation.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/15/21.
//

import Foundation
import SwiftUI

fileprivate struct DelayedAnimation: ViewModifier {
    var delay: Double
    var animation: Animation
    
    @State private var animating = false
    
    func delayAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.animating = true
        }
    }
    
    func body(content: Content) -> some View {
        content
            .animation(animating ? animation : nil)
            .onAppear(perform: delayAnimation)
    }
}

extension View {
    func delayedAnimation(
        delay: Double = 0.3,
        animation: Animation = .default
    ) -> some View {
        modifier(DelayedAnimation(delay: delay, animation: animation))
    }
}
