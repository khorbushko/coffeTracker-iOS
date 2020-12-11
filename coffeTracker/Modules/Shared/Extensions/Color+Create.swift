//
//  Color+Create.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 12/11/20.
//

import Foundation
import Foundation
import SwiftUI

extension Color {
    
    init(red: Int, green: Int, blue: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double(red) / 255.0,
            green: Double(green) / 255.0,
            blue: Double(blue) / 255.0,
            opacity: opacity
        )
    }
}
