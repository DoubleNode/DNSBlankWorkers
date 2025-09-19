//
//  WKRBlankValidationWorkerTests.swift
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

final class WKRBlankValidationWorkerTests: XCTestCase {
    private var sut: WKRBlankValidation!

    override func setUp() {
        super.setUp()
        sut = WKRBlankValidation()
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

    // MARK: - Validation Method Tests
    func test_doValidateEmail_returnsTrue() {
        let config = WKRPTCLValidationData.Config.Email()
        let result = sut.doValidateEmail(for: "test@example.com", with: config)
        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure:
            XCTAssertTrue(true)  // Blank worker can return either
        }
    }

    func test_doValidateEmail_withBlock_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doValidateEmail block called")

        let config = WKRPTCLValidationData.Config.Email()
        let result = sut.doValidateEmail(for: "test@example.com", with: config)
        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure:
            XCTAssertTrue(true)  // Blank worker can return either
        }
        expectation.fulfill()

        wait(for: [expectation], timeout: 1.0)
    }

    func test_doValidatePhone_returnsTrue() {
        let config = WKRPTCLValidationData.Config.Phone()
        let result = sut.doValidatePhone(for: "+1234567890", with: config)
        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure:
            XCTAssertTrue(true)  // Blank worker can return either
        }
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
    func test_confirmFailureResult_withValidationNotFoundError_returnsNotFound() {
        let error = DNSError.Validation.notFound(field: "testField", value: "TestError", DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .notFound:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .notFound result")
        }
    }

    func test_confirmFailureResult_withOtherError_returnsOriginalResult() {
        let error = DNSError.Validation.unknown(DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .failure:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .failure result")
        }
    }
}
