//
//  ViewStyle.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 11/30/20.
//

import Foundation
import SwiftUI

enum ViewStyle {
    
    enum Button {
        
        struct PrimaryStyle: ButtonStyle {
            func makeBody(configuration: Configuration) -> some View {
                configuration
                    .label
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.system(size: 17, weight: .semibold))
                    .padding()
                    .foregroundColor(Pallete.white)
                    .background(Pallete.blue)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Pallete.blue, lineWidth: 2)
                    )
                    .cornerRadius(8)
                    .frame(height: 50)
                    .opacity(configuration.isPressed ? 0.7 : 1.0)
            }
        }
    }
}
