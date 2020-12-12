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
    
    func testDefaultAppearenceLTR() {
        assertSnapshot(
            matching:
                Checkmark()
                .frame(width: referenceSize.width, height: referenceSize.height)
                .environment(\.layoutDirection, .leftToRight),
            as: .image
        )
    }
    
    func testDefaultAppearenceRTL() {
        assertSnapshot(
            matching:
                Checkmark()
                .frame(width: referenceSize.width, height: referenceSize.height)
                .environment(\.layoutDirection, .rightToLeft),
            as: .image
        )
    }
    
    func testDefaultAppearenceColorSchemeLight() {
        assertSnapshot(
            matching:
                Checkmark()
                .frame(width: referenceSize.width, height: referenceSize.height)
                .environment(\.colorScheme, .light),
            as: .image
        )
    }
    
    func testDefaultAppearenceColorSchemeDark() {
        assertSnapshot(
            matching:
                Checkmark()
                .frame(width: referenceSize.width, height: referenceSize.height)
                .environment(\.colorScheme, .dark),
            as: .image
        )
    }
}
