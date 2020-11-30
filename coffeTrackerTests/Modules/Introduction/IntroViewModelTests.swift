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
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        sut = IntroViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        subscriptions.removeAll()
    }
    
    // MARK: - Tests

    func testCreate() {
        XCTAssertNotNil(sut, "viewModel can't be nil")
        XCTAssertFalse(sut.isNextButtonPressed, "default value of isNextButtonPressed should be false")
    }
    
    func testPerformAction() {
        XCTAssertNotNil(sut, "viewModel can't be nil")
        XCTAssertFalse(sut.isNextButtonPressed)
        sut.perform(.next)
        XCTAssertTrue(sut.isNextButtonPressed, "isNextButtonPressed should be changed when next action executed")
    }
    
    func testNotificationOnChange() {
        XCTAssertNotNil(sut, "viewModel can't be nil")
        XCTAssertFalse(sut.isNextButtonPressed)
        XCTAssertTrue(subscriptions.isEmpty)
        
        let expect = expectation(description: "isNextButtonPressed should notify about any changes")
        
        sut.$isNextButtonPressed
            .sink { (value) in
                if value {
                    expect.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        sut.perform(.next)

        wait(for: [expect], timeout: 1)
    }
}
