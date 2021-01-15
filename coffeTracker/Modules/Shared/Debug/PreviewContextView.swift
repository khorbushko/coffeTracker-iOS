//
//  PreviewContextView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/8/21.
//

import Foundation
import SwiftUI

struct PreviewContextView<C: View>: View {
    
    var devices: [String] = [
        "iPhone X",
        "iPhone 8",
        "iPhone 11 Pro Max"
    ]
    
    let context: () -> C
    
    var body: some View {
        ForEach(
            devices,
            id: \.self
        ) { device in
            ForEach(
                ColorScheme.allCases,
                id: \.self
            ) { scheme in
                context()
                    .colorScheme(scheme)
                    .previewDevice(PreviewDevice(rawValue: device))
                    .previewDisplayName("\(scheme): \(device)")
            }
        }
    }
}
