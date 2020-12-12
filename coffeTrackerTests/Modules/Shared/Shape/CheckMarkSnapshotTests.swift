//
//  CheckMark.swift
//  coffeTrackerUITests
//
//  Created by Kyryl Horbushko on 12/12/20.
//

import Foundation
import XCTest
import SnapshotTesting
import SwiftUI

@testable import coffeTracker

final class CheckMarkSnapshotTests: XCTestCase {
    
    private let referenceSize = CGSize(width: 250, height: 250)

    func testDefaultAppearence() {
        assertSnapshot(
            matching:
                Checkmark()
                .frame(width: referenceSize.width, height: referenceSize.height),
            as: .image
        )
    }
}
