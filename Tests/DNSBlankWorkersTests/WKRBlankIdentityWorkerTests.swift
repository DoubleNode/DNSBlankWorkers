//
//  WKRBlankIdentityWorkerTests.swift
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
import DNSProtocols

final class WKRBlankIdentityWorkerTests: XCTestCase {
    private var sut: WKRBlankIdentity!

    override func setUp() {
        super.setUp()
        sut = WKRBlankIdentity()
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

    // MARK: - Worker Chain Tests
    func test_enableOption_doesNotCrash() {
        sut.enableOption("testOption")
    }

    func test_disableOption_doesNotCrash() {
        sut.disableOption("testOption")
    }

    // MARK: - Basic Functionality Tests
    func test_confirmFailureResult_withGenericError_returnsOriginalResult() {
        let error = DNSError.Auth.unknown(DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .failure:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .failure result")
        }
    }
}
