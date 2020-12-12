//
//  PermissionRequestViewModelTests.swift
//  coffeTrackerTests
//
//  Created by Kyryl Horbushko on 12/12/20.
//

import Foundation
import XCTest
import Combine

@testable import coffeTracker

final class PermissionRequestViewModelTest: XCTestCase {
    
    private var sut: PermissionRequestViewModel!
    private var healthService: FakeHealthKitService!
    private var subscription = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        healthService = FakeHealthKitService()
        sut = PermissionRequestViewModel(healthStore: healthService)
        
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
    
    func testOnCreateState() {
        XCTAssertEqual(sut.state, .initial, "state should be initial when created")
    }
    
    func testOnPerformActionReceiveSuccess() {
        let states: [Health.AccessState] = Health.AccessState.allCases
        
        states.forEach { (testedState) in
            sut = .init(healthStore: healthService)
            let expect = expectation(description: #function)
            healthService.requestResponse = testedState
            sut.$state
                .dropFirst(2)
                .sink { (newState) in
                    expect.fulfill()
                }
                .store(in: &subscription)
            
            sut.perform(.next)
            
            wait(for: [expect], timeout: 3)
        }
    }
    
    func testOnPerformActionStatusImmidiatelyChanged() {
        let expect = expectation(description: #function)
        healthService.disableResponseForDataAccess = true
        sut.$state
            .dropFirst()
            .sink { (newState) in
                XCTAssertTrue(newState == .requested)
                expect.fulfill()
            }
            .store(in: &subscription)
        
        sut.perform(.next)
        
        wait(for: [expect], timeout: 1)
    }
}

final class PermissionRequestViewModel_StateTests: XCTestCase {
    
    func testIsResponseReceivedForInitial() {
        let sut = PermissionRequestViewModel.State.initial
        XCTAssertFalse(sut.isResponseReceived)
    }
    
    func testIsResponseReceivedForRequested() {
        let sut = PermissionRequestViewModel.State.requested
        XCTAssertFalse(sut.isResponseReceived)
    }
    
    func testIsResponseReceivedForResponseReceivedFalse() {
        let sut = PermissionRequestViewModel.State.responseReceived(false)
        XCTAssertTrue(sut.isResponseReceived)
    }
    
    func testIsResponseReceivedForResponseReceivedTrue() {
        let sut = PermissionRequestViewModel.State.responseReceived(true)
        XCTAssertTrue(sut.isResponseReceived)
    }
}
