//
//  IntroViewModelTests.swift
//  coffeTrackerTests
//
//  Created by Kyryl Horbushko on 11/30/20.
//

import Foundation
import XCTest
import SwiftUI
import Combine

@testable import coffeTracker

final class IntroViewModelTests: XCTestCase {
    
    private var sut: IntroViewModel!
    private var healthService: HealthKitService!
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        sut = IntroViewModel(healthStore: healthService)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        subscriptions.removeAll()
    }
    
    // MARK: - Tests
}
