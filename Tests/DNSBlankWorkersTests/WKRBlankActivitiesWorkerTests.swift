//
//  WKRBlankActivitiesWorkerTests.swift
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

final class WKRBlankActivitiesWorkerTests: XCTestCase {
    private var sut: WKRBlankActivities!

    override func setUp() {
        super.setUp()
        sut = WKRBlankActivities()
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

    // MARK: - Activities Method Tests
    func test_doLoadActivities_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doLoadActivities called")
        let mockPlace = DAOPlace()
        let mockActivityTypes: [DAOActivityType] = []

        sut.doLoadActivities(for: mockPlace, using: mockActivityTypes) { result in
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

    func test_doLoadActivities_withProgress_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doLoadActivities with progress called")
        let mockPlace = DAOPlace()
        let mockActivityTypes: [DAOActivityType] = []

        sut.doLoadActivities(for: mockPlace, using: mockActivityTypes, with: { _, _, _, _ in }, and: { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure:
                XCTAssertTrue(true)  // Blank worker can return either
            }
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1.0)
    }

    func test_doUpdate_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doUpdate called")
        let mockActivities: [DAOActivity] = []
        let mockPlace = DAOPlace()

        sut.doUpdate(mockActivities, for: mockPlace) { result in
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

    func test_doUpdate_withProgress_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doUpdate with progress called")
        let mockActivities: [DAOActivity] = []
        let mockPlace = DAOPlace()

        sut.doUpdate(mockActivities, for: mockPlace, with: { _, _, _, _ in }, and: { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure:
                XCTAssertTrue(true)  // Blank worker can return either
            }
            expectation.fulfill()
        })

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

    func test_register_setsNextWorker() {
        let nextWorker = WKRBlankActivities()
        sut.register(nextWorker: nextWorker, for: .whenUnhandled)

        XCTAssertEqual(sut.callNextWhen, .whenUnhandled)
        XCTAssertNotNil(sut.nextWKRPTCLActivities)
        XCTAssertTrue(sut.nextWKRPTCLActivities === nextWorker)
    }

    // MARK: - Error Handling Tests
    func test_confirmFailureResult_withActivitiesNotFoundError_returnsNotFound() {
        let error = DNSError.Activities.notFound(field: "testField", value: "TestError", DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .notFound:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .notFound result")
        }
    }

    func test_confirmFailureResult_withOtherError_returnsOriginalResult() {
        let error = DNSError.Activities.unknown(DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .failure:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .failure result")
        }
    }
}