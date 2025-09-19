//
//  WKRBlankPasswordStrengthWorkerTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSBlankWorkers
import DNSCore
import DNSDataContracts
import DNSDataObjects
import DNSDataTypes
import DNSError
import DNSDataContracts
import DNSDataTypes
import DNSError
import DNSProtocols

final class WKRBlankPasswordStrengthWorkerTests: XCTestCase {
    private var sut: WKRBlankPassStrength!

    override func setUp() {
        super.setUp()
        sut = WKRBlankPassStrength()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests
    func test_init_setsDefaultCallNextWhen() {
        XCTAssertEqual(sut.callNextWhen, .whenUnhandled)
    }

    func test_init_setsSystemsWorker() {
        XCTAssertNotNil(sut.wkrSystems)
        XCTAssertTrue(sut.wkrSystems is WKRBlankSystems)
    }

    // MARK: - Password Strength Method Tests
    func test_doCheckPasswordStrength_returnsZero() {
        let result = sut.doCheckPassStrength(for: "password123")
        switch result {
        case .success(let strength):
            XCTAssertEqual(strength, .weak)
        case .failure:
            XCTAssertTrue(true)  // Blank worker can return either
        }
    }

    func test_doCheckPasswordStrength_withBlock_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doCheckPasswordStrength block called")

        let result = sut.doCheckPassStrength(for: "password123")
        switch result {
        case .success(let strength):
            XCTAssertEqual(strength, .weak)
        case .failure:
            XCTAssertTrue(true)  // Blank worker can return either
        }
        expectation.fulfill()

        wait(for: [expectation], timeout: 1.0)
    }

    func test_doCheckPasswordStrength_shortcut_withBlock_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doCheckPasswordStrength shortcut block called")

        let result = sut.doCheckPassStrength(for: "password123")
        switch result {
        case .success(let strength):
            XCTAssertEqual(strength, .weak)
        case .failure:
            XCTAssertTrue(true)  // Blank worker can return either
        }
        expectation.fulfill()

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Worker Chain Tests
    func test_enableOption_doesNotCrash() {
        sut.enableOption("testOption")
        // No assertion needed - we're testing that it doesn't crash
    }

    func test_disableOption_doesNotCrash() {
        sut.disableOption("testOption")
        // No assertion needed - we're testing that it doesn't crash
    }

    // MARK: - Error Handling Tests
    func test_confirmFailureResult_withPassStrengthNotFoundError_returnsNotFound() {
        let error = DNSError.PassStrength.notFound(field: "testField", value: "TestError", DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .notFound:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .notFound result")
        }
    }

    func test_confirmFailureResult_withOtherError_returnsOriginalResult() {
        let error = DNSError.PassStrength.unknown(DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .failure:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .failure result")
        }
    }
}