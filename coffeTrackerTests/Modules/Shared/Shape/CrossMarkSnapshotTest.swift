//
//  CrossMarkTest.swift
//  coffeTrackerTests
//
//  Created by Kyryl Horbushko on 12/12/20.
//

import Foundation
import XCTest
import SnapshotTesting
import SwiftUI

@testable import coffeTracker

final class CrossMarkSnapshotTest: XCTestCase {
    
    private let referenceSize = CGSize(width: 150, height: 50)
    
    func testDefaultAppearence() {
        assertSnapshot(
            matching:
                Crossmark()
                .frame(width: referenceSize.width, height: referenceSize.height),
            as: .image
        )
    }
}
