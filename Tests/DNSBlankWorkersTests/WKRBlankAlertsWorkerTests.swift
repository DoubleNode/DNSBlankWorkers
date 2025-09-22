//
//  WKRBlankAlertsWorkerTests.swift
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

final class WKRBlankAlertsWorkerTests: XCTestCase {
    private var sut: WKRBlankAlerts!

    override func setUp() {
        super.setUp()
        sut = WKRBlankAlerts()
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

    func test_register_setsNextWorker() {
        let nextWorker = WKRBlankAlerts()
        sut.register(nextWorker: nextWorker, for: .whenUnhandled)

        XCTAssertEqual(sut.callNextWhen, .whenUnhandled)
        XCTAssertNotNil(sut.nextWorker)
        XCTAssertTrue(sut.nextWorker === nextWorker)
    }

    // MARK: - Error Handling Tests
    func test_confirmFailureResult_withAlertsNotFoundError_returnsNotFound() {
        let error = DNSError.Alerts.notFound(field: "testField", value: "TestError", DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .notFound:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .notFound result")
        }
    }

    func test_confirmFailureResult_withOtherError_returnsOriginalResult() {
        let error = DNSError.Alerts.unknown(DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .failure:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .failure result")
        }
    }
}
