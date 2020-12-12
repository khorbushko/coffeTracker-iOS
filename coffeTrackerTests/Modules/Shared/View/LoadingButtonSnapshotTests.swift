//
//  LoadingButtonSnapshotTests.swift
//  coffeTrackerTests
//
//  Created by Kyryl Horbushko on 12/12/20.
//

import Foundation
import XCTest
import SnapshotTesting
import SwiftUI

@testable import coffeTracker

final class LoadingButtonSnapshotTests: XCTestCase {

    private let referenceSize = CGSize(width: 150, height: 150)
    
    func testLoadingAppearence() {
        assertSnapshot(
            matching:
                LoadingButton(
                    loading: .constant(true),
                    foregroundColor: Color.white,
                    backgroundColor: Color.blue,
                    action: {
                        
                    },
                    label: Text("Title")
                )
                .frame(width: referenceSize.width, height: referenceSize.height),
            as: .image
        )
    }
    
    func testNormalAppearence() {
        assertSnapshot(
            matching:
                LoadingButton(
                    loading: .constant(false),
                    foregroundColor: Color.white,
                    backgroundColor: Color.blue,
                    action: {
                        
                    },
                    label: Text("Title")
                )
                .frame(width: referenceSize.width, height: referenceSize.height),
            as: .image
        )
    }
}
