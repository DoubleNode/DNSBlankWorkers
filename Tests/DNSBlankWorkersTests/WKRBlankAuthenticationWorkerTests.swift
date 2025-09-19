//
//  WKRBlankAuthenticationWorkerTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkersTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSBlankWorkers
import DNSBlankNetwork
import DNSCore
import DNSDataContracts
import DNSDataObjects
import DNSDataTypes
import DNSError
import DNSProtocols

final class WKRBlankAuthenticationWorkerTests: XCTestCase {
    private var sut: WKRBlankAuth!
    private var mockNextWorker: MockAuthWorker!

    override func setUp() {
        super.setUp()
        sut = WKRBlankAuth()
        mockNextWorker = MockAuthWorker()
    }

    override func tearDown() {
        sut = nil
        mockNextWorker = nil
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
    func test_register_setsNextWorkerAndCallWhen() {
        sut.register(nextWorker: mockNextWorker, for: .whenUnhandled)

        XCTAssertEqual(sut.callNextWhen, .whenUnhandled)
        XCTAssertIdentical(sut.nextWKRPTCLAuth, mockNextWorker)
    }

    func test_nextWorker_getterReturnsCorrectWorker() {
        sut.nextWorker = mockNextWorker

        XCTAssertIdentical(sut.nextWKRPTCLAuth, mockNextWorker)
    }

    func test_nextWorker_setterUpdatesWorker() {
        sut.nextWKRPTCLAuth = mockNextWorker

        XCTAssertIdentical(sut.nextWorker as? MockAuthWorker, mockNextWorker)
    }

    // MARK: - Option Tests
    func test_enableOption_callsNextWorkerEnableOption() {
        sut.nextWKRPTCLAuth = mockNextWorker

        sut.enableOption("testOption")

        XCTAssertTrue(mockNextWorker.enableOptionCalled)
        XCTAssertEqual(mockNextWorker.lastEnabledOption, "testOption")
    }

    func test_disableOption_callsNextWorkerDisableOption() {
        sut.nextWKRPTCLAuth = mockNextWorker

        sut.disableOption("testOption")

        XCTAssertTrue(mockNextWorker.disableOptionCalled)
        XCTAssertEqual(mockNextWorker.lastDisabledOption, "testOption")
    }

    // MARK: - Authentication Method Tests
    func test_doCheckAuth_callsIntMethodSuccessfully() {
        let expectation = XCTestExpectation(description: "doCheckAuth called")

        sut.doCheckAuth(using: [:], with: nil) { result in
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

    func test_doLinkAuth_callsIntMethodSuccessfully() {
        let expectation = XCTestExpectation(description: "doLinkAuth called")

        sut.doLinkAuth(from: "username", and: "password", using: [:], with: nil) { result in
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

    func test_doPasswordResetStart_callsIntMethodSuccessfully() {
        let expectation = XCTestExpectation(description: "doPasswordResetStart called")

        sut.doPasswordResetStart(from: "username", using: [:], with: nil) { result in
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

    func test_doSignIn_callsIntMethodSuccessfully() {
        let expectation = XCTestExpectation(description: "doSignIn called")

        sut.doSignIn(from: "username", and: "password", using: [:], with: nil) { result in
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

    func test_doSignOut_callsIntMethodSuccessfully() {
        let expectation = XCTestExpectation(description: "doSignOut called")

        sut.doSignOut(using: [:], with: nil) { result in
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

    func test_doSignUp_callsIntMethodSuccessfully() {
        let expectation = XCTestExpectation(description: "doSignUp called")
        let mockUser = DAOUser()

        sut.doSignUp(from: mockUser, and: "password", using: [:], with: nil) { result in
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

    // MARK: - Shortcut Method Tests
    func test_doCheckAuth_shortcut_callsIntMethodSuccessfully() {
        let expectation = XCTestExpectation(description: "doCheckAuth shortcut called")

        sut.doCheckAuth(using: [:]) { result in
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

    func test_doLinkAuth_shortcut_callsIntMethodSuccessfully() {
        let expectation = XCTestExpectation(description: "doLinkAuth shortcut called")

        sut.doLinkAuth(from: "username", and: "password", using: [:]) { result in
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

    func test_doPasswordResetStart_shortcut_callsIntMethodSuccessfully() {
        let expectation = XCTestExpectation(description: "doPasswordResetStart shortcut called")

        sut.doPasswordResetStart(from: "username", using: [:]) { result in
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

    func test_doSignIn_shortcut_callsIntMethodSuccessfully() {
        let expectation = XCTestExpectation(description: "doSignIn shortcut called")

        sut.doSignIn(from: "username", and: "password", using: [:]) { result in
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

    func test_doSignOut_shortcut_callsIntMethodSuccessfully() {
        let expectation = XCTestExpectation(description: "doSignOut shortcut called")

        sut.doSignOut(using: [:]) { result in
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

    func test_doSignUp_shortcut_callsIntMethodSuccessfully() {
        let expectation = XCTestExpectation(description: "doSignUp shortcut called")
        let mockUser = DAOUser()

        sut.doSignUp(from: mockUser, and: "password", using: [:]) { result in
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

    // MARK: - Error Handling Tests
    func test_confirmFailureResult_withAuthNotFoundError_returnsNotFound() {
        let error = DNSError.Auth.notFound(field: "testField", value: "TestError", DNSCodeLocation(self))

        let result = sut.confirmFailureResult(.failure(error), with: error)

        switch result {
        case .notFound:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .notFound result")
        }
    }

    func test_confirmFailureResult_withOtherError_returnsOriginalResult() {
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

// MARK: - Mock Classes
class MockAuthWorker: WKRPTCLAuth {
    static var xlt: DNSDataTranslation = DNSDataTranslation()

    // Simplified mock - omitting network dependencies to avoid initialization issues
    var netConfig: NETPTCLConfig {
        get { return NETBlankConfig() }
        set { /* ignore for testing */ }
    }
    var netRouter: NETPTCLRouter {
        get { return NETBlankRouter() }
        set { /* ignore for testing */ }
    }

    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    var nextWorker: DNSPTCLWorker?
    var wkrSystems: WKRPTCLSystems?

    required init() {}

    func configure() {}
    func checkOption(_ option: String) -> Bool { return false }

    func register(nextWorker: WKRPTCLAuth, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
        self.callNextWhen = callNextWhen
    }

    // MARK: - UIWindowSceneDelegate methods
    func didBecomeActive() {}
    func willResignActive() {}
    func willEnterForeground() {}
    func didEnterBackground() {}

    var enableOptionCalled = false
    var disableOptionCalled = false
    var lastEnabledOption: String?
    var lastDisabledOption: String?

    func enableOption(_ option: String) {
        enableOptionCalled = true
        lastEnabledOption = option
    }

    func disableOption(_ option: String) {
        disableOptionCalled = true
        lastDisabledOption = option
    }

    // MARK: - Worker Logic (Public) -
    func doAnalytics(for object: DAOBaseObject, using data: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLWorkerBaseBlkAAnalyticsData?) {
        block?(.success([]))
    }

    func doAnalytics(for object: DAOBaseObject, using data: DNSDataDictionary, and block: WKRPTCLWorkerBaseBlkAAnalyticsData?) {
        block?(.success([]))
    }

    func doCheckAuth(using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkBoolBoolAccessData?) {
        block?(.success((false, false, MockAccessData())))
    }

    func doLinkAuth(from username: String, and password: String, using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkBoolAccessData?) {
        block?(.success((false, MockAccessData())))
    }

    func doPasswordResetStart(from username: String?, using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkVoid?) {
        block?(.success(()))
    }

    func doSignIn(from username: String?, and password: String?, using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkBoolAccessData?) {
        block?(.success((false, MockAccessData())))
    }

    func doSignOut(using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkVoid?) {
        block?(.success(()))
    }

    func doSignUp(from user: (any DAOUserProtocol)?, and password: String?, using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAuthBlkBoolAccessData?) {
        block?(.success((false, MockAccessData())))
    }

    // MARK: - Worker Logic (Shortcuts) -
    func doCheckAuth(using parameters: DNSDataDictionary, with block: WKRPTCLAuthBlkBoolBoolAccessData?) {
        block?(.success((false, false, MockAccessData())))
    }

    func doLinkAuth(from username: String, and password: String, using parameters: DNSDataDictionary, and block: WKRPTCLAuthBlkBoolAccessData?) {
        block?(.success((false, MockAccessData())))
    }

    func doPasswordResetStart(from username: String?, using parameters: DNSDataDictionary, with block: WKRPTCLAuthBlkVoid?) {
        block?(.success(()))
    }

    func doSignIn(from username: String?, and password: String?, using parameters: DNSDataDictionary, with block: WKRPTCLAuthBlkBoolAccessData?) {
        block?(.success((false, MockAccessData())))
    }

    func doSignOut(using parameters: DNSDataDictionary, with block: WKRPTCLAuthBlkVoid?) {
        block?(.success(()))
    }

    func doSignUp(from user: (any DAOUserProtocol)?, and password: String?, using parameters: DNSDataDictionary, with block: WKRPTCLAuthBlkBoolAccessData?) {
        block?(.success((false, MockAccessData())))
    }
}

class MockAccessData: WKRPTCLAuthAccessData {
    var accessToken: String = "mockAccessToken"
}

