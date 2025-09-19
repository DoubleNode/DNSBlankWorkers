//
//  WKRBlankAnalyticsWorkerTests.swift
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

final class WKRBlankAnalyticsWorkerTests: XCTestCase {
    private var sut: WKRBlankAnalytics!
    private var mockNextWorker: MockAnalyticsWorker!

    override func setUp() {
        super.setUp()
        sut = WKRBlankAnalytics()
        mockNextWorker = MockAnalyticsWorker()
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
        XCTAssertIdentical(sut.nextWKRPTCLAnalytics, mockNextWorker)
    }

    func test_nextWorker_getterReturnsCorrectWorker() {
        sut.nextWorker = mockNextWorker

        XCTAssertIdentical(sut.nextWKRPTCLAnalytics, mockNextWorker)
    }

    func test_nextWorker_setterUpdatesWorker() {
        sut.nextWKRPTCLAnalytics = mockNextWorker

        XCTAssertIdentical(sut.nextWorker as? MockAnalyticsWorker, mockNextWorker)
    }

    // MARK: - Option Tests
    func test_enableOption_callsNextWorkerEnableOption() {
        sut.nextWKRPTCLAnalytics = mockNextWorker

        sut.enableOption("testOption")

        XCTAssertTrue(mockNextWorker.enableOptionCalled)
        XCTAssertEqual(mockNextWorker.lastEnabledOption, "testOption")
    }

    func test_disableOption_callsNextWorkerDisableOption() {
        sut.nextWKRPTCLAnalytics = mockNextWorker

        sut.disableOption("testOption")

        XCTAssertTrue(mockNextWorker.disableOptionCalled)
        XCTAssertEqual(mockNextWorker.lastDisabledOption, "testOption")
    }

    // MARK: - Analytics Method Tests
    func test_doAutoTrack_returnsSuccess() {
        let result = sut.doAutoTrack(class: "TestClass", method: "testMethod", properties: [:], options: [:])

        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }

    func test_doGroup_returnsSuccess() {
        let result = sut.doGroup(groupId: "testGroup", traits: [:], options: [:])

        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }

    func test_doIdentify_returnsSuccess() {
        let result = sut.doIdentify(userId: "testUser", traits: [:], options: [:])

        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }

    func test_doScreen_returnsSuccess() {
        let result = sut.doScreen(screenTitle: "TestScreen", properties: [:], options: [:])

        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }

    func test_doTrack_returnsSuccess() {
        let event = WKRPTCLAnalyticsEvents.screenView
        let result = sut.doTrack(event: event, properties: [:], options: [:])

        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }

    // MARK: - Shortcut Methods Tests
    func test_doAutoTrack_shortcut_returnsSuccess() {
        let result = sut.doAutoTrack(class: "TestClass", method: "testMethod")

        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }

    func test_doGroup_shortcut_returnsSuccess() {
        let result = sut.doGroup(groupId: "testGroup")

        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }

    func test_doIdentify_shortcut_returnsSuccess() {
        let result = sut.doIdentify(userId: "testUser")

        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }

    func test_doScreen_shortcut_returnsSuccess() {
        let result = sut.doScreen(screenTitle: "TestScreen")

        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }

    func test_doTrack_shortcut_returnsSuccess() {
        let event = WKRPTCLAnalyticsEvents.screenView
        let result = sut.doTrack(event: event)

        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }

    // MARK: - Error Handling Tests
    func test_confirmFailureResult_withAnalyticsNotFoundError_returnsNotFound() {
        let error = DNSError.Analytics.notFound(field: "testField", value: "TestError", DNSCodeLocation(self))

        let result = sut.confirmFailureResult(.failure(error), with: error)

        switch result {
        case .notFound:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected .notFound result")
        }
    }

    func test_confirmFailureResult_withOtherError_returnsOriginalResult() {
        let error = DNSError.Analytics.unknown(DNSCodeLocation(self))

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
class MockAnalyticsWorker: WKRPTCLAnalytics {
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

    func register(nextWorker: WKRPTCLAnalytics, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
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

    // MARK: - Auto-Track -
    func doAutoTrack(class: String, method: String) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    func doAutoTrack(class: String, method: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    func doAutoTrack(class: String, method: String, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    // MARK: - Group -
    func doGroup(groupId: String) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    func doGroup(groupId: String, traits: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    func doGroup(groupId: String, traits: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    // MARK: - Identify -
    func doIdentify(userId: String) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    func doIdentify(userId: String, traits: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    func doIdentify(userId: String, traits: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    func doIdentify(userId: String, with traits: DNSDataDictionary, and block: WKRPTCLAnalyticsBlkVoid?) {
        block?(.success(()))
    }

    func doIdentify(userId: String, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAnalyticsBlkVoid?) {
        block?(.success(()))
    }

    func doIdentify(userId: String, with traits: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAnalyticsBlkVoid?) {
        block?(.success(()))
    }

    // MARK: - Screen -
    func doScreen(screenTitle: String) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    func doScreen(screenTitle: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    func doScreen(screenTitle: String, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    // MARK: - Track -
    func doTrack(event: WKRPTCLAnalytics.Events) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }

    func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
}

