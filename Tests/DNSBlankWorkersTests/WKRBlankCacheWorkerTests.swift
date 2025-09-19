//
//  WKRBlankCacheWorkerTests.swift
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

final class WKRBlankCacheWorkerTests: XCTestCase {
    private var sut: WKRBlankCache!

    override func setUp() {
        super.setUp()
        sut = WKRBlankCache()
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

    // MARK: - Cache Method Tests
    func test_doReadObject_returnsPublisher() {
        let publisher = sut.doReadObject(for: "testKey", with: nil)
        XCTAssertNotNil(publisher)
    }

    func test_doReadObject_withProgress_returnsPublisher() {
        let publisher = sut.doReadObject(for: "testKey", with: nil)
        XCTAssertNotNil(publisher)
    }

    func test_doUpdate_returnsPublisher() {
        let testData = ["key": "value"]
        let publisher = sut.doUpdate(object: testData, for: "testKey", with: nil)
        XCTAssertNotNil(publisher)
    }

    func test_doDeleteObject_returnsPublisher() {
        let publisher = sut.doDeleteObject(for: "testKey", with: nil)
        XCTAssertNotNil(publisher)
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
    func test_confirmFailureResult_withCacheNotFoundError_returnsNotFound() {
        let error = DNSError.Cache.notFound(field: "testField", value: "TestError", DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .notFound:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .notFound result")
        }
    }

    func test_confirmFailureResult_withOtherError_returnsOriginalResult() {
        let error = DNSError.Cache.unknown(DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .failure:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .failure result")
        }
    }
}