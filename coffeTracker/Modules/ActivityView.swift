//
//  ActivityView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 12/1/20.
//

import Foundation
import SwiftUI

struct ActivityView: View {
    
    @State private var isAnimating: Bool = false
    var elementsCount: CGFloat = 5
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            ForEach(0..<5) { idx in
                let maxScale = (1 - CGFloat(idx) / elementsCount)
                let minScale = (0.2 + CGFloat(idx) / elementsCount)
                
                Group {
                    Circle()
                        .frame(
                            width: size.width / elementsCount,
                            height: size.height / elementsCount
                        )
                        .scaleEffect(self.isAnimating ? minScale: maxScale)
                        .offset(y: size.width / (elementsCount * 2) - size.height / 2)
                }
                .frame(width: size.width, height: size.height)
                .rotationEffect(self.isAnimating ? .degrees(360) : .degrees(0))
                .animation(
                    Animation
                            .timingCurve(
                                0.5,
                                0.15 + Double(idx) / 5,
                                0.25,
                                1,
                                duration: 1.5
                            )
                            .repeatForever(autoreverses: false)
                )
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            self.isAnimating = true
        }
    }
}
