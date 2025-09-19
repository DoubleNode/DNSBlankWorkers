//
//  WKRBlankBeaconsWorkerTests.swift
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

final class WKRBlankBeaconsWorkerTests: XCTestCase {
    private var sut: WKRBlankBeacons!

    override func setUp() {
        super.setUp()
        sut = WKRBlankBeacons()
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

    // MARK: - Beacon Method Tests
    func test_doLoadBeacons_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doLoadBeacons called")
        let mockPlace = DAOPlace()

        sut.doLoadBeacons(in: mockPlace, with: nil) { result in
            switch result {
            case .success(let beacons):
                XCTAssertTrue(beacons.isEmpty)
            case .failure(let error):
                XCTFail("Expected success, got failure: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_doLoadBeacons_shortcut_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doLoadBeacons shortcut called")
        let mockPlace = DAOPlace()

        sut.doLoadBeacons(in: mockPlace) { result in
            switch result {
            case .success(let beacons):
                XCTAssertTrue(beacons.isEmpty)
            case .failure(let error):
                XCTFail("Expected success, got failure: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_doStopRangeBeacons_returnsSuccess() {
        let result = sut.doStopRangeBeacons(for: "testKey")
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
    func test_confirmFailureResult_withBeaconsNotFoundError_returnsNotFound() {
        let error = DNSError.Beacons.notFound(field: "testField", value: "TestError", DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .notFound:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .notFound result")
        }
    }

    func test_confirmFailureResult_withOtherError_returnsOriginalResult() {
        let error = DNSError.Beacons.unknown(DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .failure:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .failure result")
        }
    }
}

