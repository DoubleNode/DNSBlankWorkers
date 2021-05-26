//
//  WKRBlankAnalyticsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankAnalyticsWorker: WKRBlankBaseWorker, PTCLAnalytics_Protocol
{
    public var callNextWhen: PTCLCallNextWhen = .whenUnhandled
    public var nextWorker: PTCLAnalytics_Protocol?

    public required init() {
        super.init()
    }
    public required init(call callNextWhen: PTCLCallNextWhen,
                         nextWorker: PTCLAnalytics_Protocol) {
        super.init()
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
    public func runDo(runNext: PTCLCallBlock?,
                      doWork: PTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Auto-Track -
    open func doAutoTrack(class: String, method: String) throws {
        try self.doAutoTrack(class: `class`, method: method, properties: [:], options: [:])
    }
    open func doAutoTrack(class: String, method: String, properties: [String: Any]) throws {
        try self.doAutoTrack(class: `class`, method: method, properties: properties, options: [:])
    }
    open func doAutoTrack(class: String, method: String, properties: [String: Any], options: [String: Any]) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doAutoTrack(class: `class`, method: method, properties: properties, options: options)
        }
    }

    // MARK: - Group -
    open func doGroup(groupId: String) throws {
        try self.doGroup(groupId: groupId, traits: [:], options: [:])
    }
    open func doGroup(groupId: String, traits: [String: Any]) throws {
        try self.doGroup(groupId: groupId, traits: traits, options: [:])
    }
    open func doGroup(groupId: String, traits: [String: Any], options: [String: Any]) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doGroup(groupId: groupId, traits: traits, options: options)
        }
    }

    // MARK: - Identify -
    open func doIdentify(userId: String) throws {
        try self.doIdentify(userId: userId, traits: [:], options: [:])
    }
    open func doIdentify(userId: String, traits: [String: Any]) throws {
        try self.doIdentify(userId: userId, traits: traits, options: [:])
    }
    open func doIdentify(userId: String, traits: [String: Any], options: [String: Any]) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doIdentify(userId: userId, traits: traits, options: options)
        }
    }

    // MARK: - Screen -
    open func doScreen(screenTitle: String) throws {
        try self.doScreen(screenTitle: screenTitle, properties: [:], options: [:])
    }
    open func doScreen(screenTitle: String, properties: [String: Any]) throws {
        try self.doScreen(screenTitle: screenTitle, properties: properties, options: [:])
    }
    open func doScreen(screenTitle: String, properties: [String: Any], options: [String: Any]) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doScreen(screenTitle: screenTitle, properties: properties, options: options)
        }
    }

    // MARK: - Track -
    open func doTrack(event: PTCLAnalyticsEvents) throws {
        return try self.doTrack(event: event, properties: [:], options: [:])
    }
    open func doTrack(event: PTCLAnalyticsEvents, properties: [String: Any]) throws {
        return try self.doTrack(event: event, properties: properties, options: [:])
    }
    open func doTrack(event: PTCLAnalyticsEvents, properties: [String: Any] = [:], options: [String: Any] = [:]) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doTrack(event: event, properties: properties, options: options)
        }
    }
}
