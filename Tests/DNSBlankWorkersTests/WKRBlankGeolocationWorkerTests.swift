//
//  WKRBlankGeolocationWorkerTests.swift
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

final class WKRBlankGeolocationWorkerTests: XCTestCase {
    private var sut: WKRBlankGeo!

    override func setUp() {
        super.setUp()
        sut = WKRBlankGeo()
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

    // MARK: - Geolocation Method Tests
    func test_doLocate_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doLocate called")

        sut.doLocate(with: nil) { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure:
                XCTAssertTrue(true)  // Blank worker can return either
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_doLocate_shortcut_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doLocate shortcut called")

        sut.doLocate { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure:
                XCTAssertTrue(true)  // Blank worker can return either
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_doStopTrackLocation_returnsSuccess() {
        let result = sut.doStopTrackLocation(for: "testKey")
        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
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
    func test_confirmFailureResult_withGeoNotFoundError_returnsNotFound() {
        let error = DNSError.Geo.notFound(field: "testField", value: "TestError", DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .notFound:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .notFound result")
        }
    }

    func test_confirmFailureResult_withOtherError_returnsOriginalResult() {
        let error = DNSError.Geo.unknown(DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .failure:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .failure result")
        }
    }
}