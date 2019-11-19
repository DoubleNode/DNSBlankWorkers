//
//  WKRBlankAnalyticsWorker.swift
//  DoubleNode Core - DNSBlankWorkers
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import DNSProtocols

open class WKRBlankAnalyticsWorker: PTCLAnalytics_Protocol
{
    public var nextWorker: PTCLAnalytics_Protocol?
    
    public required init() {

    }

    public required init(nextWorker: PTCLAnalytics_Protocol) {
        self.nextWorker = nextWorker
    }

    open func configure() {

    }

    open func enableOption(option: String) {
        nextWorker?.enableOption(option: option)
    }

    open func disableOption(option: String) {
        nextWorker?.disableOption(option: option)
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
            throw DNSBlankWorkersError.notImplemented(domain: "com.doublenode.\(type(of: self))",
                file: "\(#file)",
                line: "\(#line)",
                method: "\(#function)")
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
            throw DNSBlankWorkersError.notImplemented(domain: "com.doublenode.\(type(of: self))",
                file: "\(#file)",
                line: "\(#line)",
                method: "\(#function)")
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
            throw DNSBlankWorkersError.notImplemented(domain: "com.doublenode.\(type(of: self))",
                file: "\(#file)",
                line: "\(#line)",
                method: "\(#function)")
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
            throw DNSBlankWorkersError.notImplemented(domain: "com.doublenode.\(type(of: self))",
                file: "\(#file)",
                line: "\(#line)",
                method: "\(#function)")
        }

        try nextWorker!.doGroup(groupId: groupId, traits: traits, options: options)
    }
}
