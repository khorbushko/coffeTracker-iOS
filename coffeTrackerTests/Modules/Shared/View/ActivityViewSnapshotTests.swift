//
//  ActivityViewSnapshotTests.swift
//  coffeTrackerTests
//
//  Created by Kyryl Horbushko on 12/12/20.
//

import Foundation
import XCTest
import SnapshotTesting
import SwiftUI

@testable import coffeTracker

final class ActivityViewSnapshotTests: XCTestCase {
    
    private let referenceSize = CGSize(width: 150, height: 50)
    
    func testDefaultAppearence() {
        assertSnapshot(
            matching:
                ActivityView()
                .foregroundColor(.blue)
                .frame(width: referenceSize.width, height: referenceSize.height),
            as: .image
        )
    }
    
    func testCustomAppearence() {
        assertSnapshot(
            matching:
                ActivityView(elementsCount: 10)
                .foregroundColor(.red)
                .frame(width: referenceSize.width, height: referenceSize.height),
            as: .image
        )
    }
}
