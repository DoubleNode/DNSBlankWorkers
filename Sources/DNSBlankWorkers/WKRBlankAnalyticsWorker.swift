//
//  WKRBlankAnalyticsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankAnalyticsWorker: WKRBlankBaseWorker, WKRPTCLAnalytics {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAnalytics?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLAnalytics,
                         for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.callNextWhen = callNextWhen
        self.nextWorker = nextWorker
    }

    override open func disableOption(_ option: String) {
        super.disableOption(option)
        nextWorker?.disableOption(option)
    }
    override open func enableOption(_ option: String) {
        super.enableOption(option)
        nextWorker?.enableOption(option)
    }
    @discardableResult
    public func runDo(runNext: DNSPTCLCallBlock?,
                      doWork: DNSPTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doAutoTrack(class: String, method: String, properties: [String: Any], options: [String: Any]) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doAutoTrack(class: `class`, method: method, properties: properties, options: options)
        },
        doWork: {
            return try self.intDoAutoTrack(class: `class`, method: method, properties: properties, options: options, then: $0)
        })
    }
    public func doGroup(groupId: String, traits: [String: Any], options: [String: Any]) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doGroup(groupId: groupId, traits: traits, options: options)
        },
        doWork: {
            return try self.intDoGroup(groupId: groupId, traits: traits, options: options, then: $0)
        })
    }
    public func doIdentify(userId: String, traits: [String: Any], options: [String: Any]) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doIdentify(userId: userId, traits: traits, options: options)
        },
        doWork: {
            return try self.intDoIdentify(userId: userId, traits: traits, options: options, then: $0)
        })
    }
    public func doScreen(screenTitle: String, properties: [String: Any], options: [String: Any]) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doScreen(screenTitle: screenTitle, properties: properties, options: options)
        },
        doWork: {
            return try self.intDoScreen(screenTitle: screenTitle, properties: properties, options: options, then: $0)
        })
    }
    public func doTrack(event: WKRPTCLAnalyticsEvents, properties: [String: Any] = [:], options: [String: Any] = [:]) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doTrack(event: event, properties: properties, options: options)
        },
        doWork: {
            return try self.intDoTrack(event: event, properties: properties, options: options, then: $0)
        })
    }

    // MARK: - Internal Work Methods
    open func intDoAutoTrack(class: String, method: String, properties: [String: Any], options: [String: Any],
                             then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoGroup(groupId: String, traits: [String: Any], options: [String: Any],
                         then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoIdentify(userId: String, traits: [String: Any], options: [String: Any],
                            then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoScreen(screenTitle: String, properties: [String: Any], options: [String: Any],
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoTrack(event: WKRPTCLAnalyticsEvents, properties: [String: Any] = [:], options: [String: Any] = [:],
                         then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }

    // MARK: - Shortcuts -
    open func doAutoTrack(class: String, method: String) throws {
        try self.doAutoTrack(class: `class`, method: method, properties: [:], options: [:])
    }
    open func doAutoTrack(class: String, method: String, properties: [String: Any]) throws {
        try self.doAutoTrack(class: `class`, method: method, properties: properties, options: [:])
    }
    open func doGroup(groupId: String) throws {
        try self.doGroup(groupId: groupId, traits: [:], options: [:])
    }
    open func doGroup(groupId: String, traits: [String: Any]) throws {
        try self.doGroup(groupId: groupId, traits: traits, options: [:])
    }
    open func doIdentify(userId: String) throws {
        try self.doIdentify(userId: userId, traits: [:], options: [:])
    }
    open func doIdentify(userId: String, traits: [String: Any]) throws {
        try self.doIdentify(userId: userId, traits: traits, options: [:])
    }
    open func doScreen(screenTitle: String) throws {
        try self.doScreen(screenTitle: screenTitle, properties: [:], options: [:])
    }
    open func doScreen(screenTitle: String, properties: [String: Any]) throws {
        try self.doScreen(screenTitle: screenTitle, properties: properties, options: [:])
    }
    open func doTrack(event: WKRPTCLAnalyticsEvents) throws {
        return try self.doTrack(event: event, properties: [:], options: [:])
    }
    open func doTrack(event: WKRPTCLAnalyticsEvents, properties: [String: Any]) throws {
        return try self.doTrack(event: event, properties: properties, options: [:])
    }
}
