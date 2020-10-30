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
    public var nextWorker: PTCLAnalytics_Protocol?

    public required init() {
        super.init()
    }

    public required init(nextWorker: PTCLAnalytics_Protocol) {
        super.init()
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

    // MARK: - Identify

    open func doIdentify(userId: String) throws {
        try self.doIdentify(userId: userId, traits: nil, options: nil)
    }
    open func doIdentify(userId: String, traits: [String: Any]?) throws {
        try self.doIdentify(userId: userId, traits: traits, options: nil)
    }
    open func doIdentify(userId: String,
                         traits: [String: Any]? = nil,
                         options: [String: Any]? = nil) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doIdentify(userId: userId, traits: traits, options: options)
    }

    // MARK: - Track
    open func doTrack(event: String) throws {
        try self.doTrack(event: event, properties: nil, options: nil)
    }
    open func doTrack(event: String, properties: [String: Any]?) throws {
        try self.doTrack(event: event, properties: properties, options: nil)
    }
    open func doTrack(event: String, properties: [String: Any]? = nil, options: [String: Any]? = nil) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doTrack(event: event, properties: properties, options: options)
    }

    // MARK: - Screen
    open func doScreen(screenTitle: String) throws {
        try self.doScreen(screenTitle: screenTitle, properties: nil, options: nil)
    }
    open func doScreen(screenTitle: String, properties: [String: Any]?) throws {
        try self.doScreen(screenTitle: screenTitle, properties: properties, options: nil)
    }
    open func doScreen(screenTitle: String,
                       properties: [String: Any]? = nil,
                       options: [String: Any]? = nil) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doScreen(screenTitle: screenTitle, properties: properties, options: options)
    }

    // MARK: - Group
    open func doGroup(groupId: String) throws {
        try self.doGroup(groupId: groupId, traits: nil, options: nil)
    }
    open func doGroup(groupId: String, traits: [String: Any]?) throws {
        try self.doGroup(groupId: groupId, traits: traits, options: nil)
    }
    open func doGroup(groupId: String,
                      traits: [String: Any]? = nil,
                      options: [String: Any]? = nil) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doGroup(groupId: groupId, traits: traits, options: options)
    }
}
