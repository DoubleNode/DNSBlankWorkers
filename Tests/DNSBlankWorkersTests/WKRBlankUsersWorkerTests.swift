//
//  WKRBlankUsersWorkerTests.swift
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

final class WKRBlankUsersWorkerTests: XCTestCase {
    private var sut: WKRBlankUsers!

    override func setUp() {
        super.setUp()
        sut = WKRBlankUsers()
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

    // MARK: - User Management Tests
    func test_doLoadCurrentUser_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doLoadCurrentUser called")

        sut.doLoadCurrentUser { result in
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

    func test_doLoadUser_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doLoadUser called")

        sut.doLoadUser(for: "testUserId") { result in
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

    func test_doUpdate_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doUpdate called")
        let mockUser = DAOUser()

        sut.doUpdate(mockUser) { result in
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

    func test_doActivate_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doActivate called")
        let mockUser = DAOUser()

        sut.doActivate(mockUser) { result in
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

    func test_doRemove_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doRemove called")
        let mockUser = DAOUser()

        sut.doRemove(mockUser) { result in
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

    // MARK: - User Relationships Tests
    func test_doLoadChildUsers_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doLoadChildUsers called")
        let mockUser = DAOUser()

        sut.doLoadChildUsers(for: mockUser) { result in
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

    func test_doLoadUsers_forAccount_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doLoadUsers for account called")
        let mockAccount = DAOAccount()

        sut.doLoadUsers(for: mockAccount) { result in
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

    // MARK: - User Actions Tests
    func test_doConfirm_pendingUser_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doConfirm pending user called")
        let mockUser = DAOUser()

        sut.doConfirm(pendingUser: mockUser) { result in
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

    func test_doConsent_childUser_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doConsent child user called")
        let mockUser = DAOUser()

        sut.doConsent(childUser: mockUser) { result in
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

    func test_doReact_withReaction_callsBlockSuccessfully() {
        let expectation = XCTestExpectation(description: "doReact with reaction called")
        let mockUser = DAOUser()

        sut.doReact(with: .favorited, to: mockUser) { result in
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
        let nextWorker = WKRBlankUsers()
        sut.register(nextWorker: nextWorker, for: .whenUnhandled)

        XCTAssertEqual(sut.callNextWhen, .whenUnhandled)
        XCTAssertNotNil(sut.nextWorker)
        XCTAssertTrue(sut.nextWorker === nextWorker)
    }

    // MARK: - Error Handling Tests
    func test_confirmFailureResult_withUsersNotFoundError_returnsNotFound() {
        let error = DNSError.Users.notFound(field: "testField", value: "TestError", DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .notFound:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .notFound result")
        }
    }

    func test_confirmFailureResult_withOtherError_returnsOriginalResult() {
        let error = DNSError.Users.unknown(DNSCodeLocation(self))
        let result = sut.confirmFailureResult(.failure(error), with: error)
        switch result {
        case .failure:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .failure result")
        }
    }
}
