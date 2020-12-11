//
//  Color+CreateTests.swift
//  coffeTrackerTests
//
//  Created by Kyryl Horbushko on 12/11/20.
//

import Foundation
import SwiftUI
import XCTest

@testable import coffeTracker

final class ColorCreateTests: XCTestCase {
    
    func testColorCreation() {
        let r: Double = 155
        let g: Double = 155
        let b: Double = 155
        let a: Double = 0.3
        
        let color = Color(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0,
            opacity: a
        )
        
        let modColor = Color(
            red: Int(r),
            green: Int(g),
            blue: Int(b),
            opacity: a
        )
        
        XCTAssertEqual(
            color,
            modColor,
            "color should be correctly created using custom init"
        )
    }
}
