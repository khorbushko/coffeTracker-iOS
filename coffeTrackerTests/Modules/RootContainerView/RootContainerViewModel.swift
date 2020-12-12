//
//  RootContainerViewModel.swift
//  coffeTrackerTests
//
//  Created by Kyryl Horbushko on 12/12/20.
//

import Foundation
import XCTest
import Combine

@testable import coffeTracker

final class RootContainerViewModelTests: XCTestCase {
    
    private var sut: RootContainerViewModel!
    private var healthService: FakeHealthKitService!
    private var subscription = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        healthService = FakeHealthKitService()
        sut = RootContainerViewModel(healthStore: healthService)
        
        XCTAssertNotNil(healthService)
        XCTAssertNotNil(sut)
        XCTAssertTrue(subscription.isEmpty)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        healthService = nil
        subscription.removeAll()
        
        XCTAssertNil(sut)
        XCTAssertNil(healthService)
    }
    
    // MARK: - Tests
    
    func testInitialValueForShouldAskPermission() {
        XCTAssertFalse(sut.shouldAskPermission)
    }

    func testCheckAppleHealthRequestResponse() {
        healthService.askDataAccessDone = true
        
        let expect = expectation(description: #function)
        
        sut.$shouldAskPermission
            .dropFirst()
            .sink { (value) in
                XCTAssertTrue(value)
                expect.fulfill()
            }
            .store(in: &subscription)
        
        sut.checkAppleHealthRequest()
        
        wait(for: [expect], timeout: 1)
    }
}
