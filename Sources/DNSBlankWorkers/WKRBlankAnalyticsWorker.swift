//
//  WKRBlankAnalyticsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSError
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
                      doWork: DNSPTCLCallResultBlock = { return $0?(.unhandled) }) -> Any? {
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doAutoTrack(class: String, method: String, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return self.runDo(runNext: {
            return self.nextWorker?.doAutoTrack(class: `class`, method: method, properties: properties, options: options)
        },
        doWork: {
            return self.intDoAutoTrack(class: `class`, method: method, properties: properties, options: options, then: $0)
        }) as! WKRPTCLAnalyticsResVoid // swiftlint:disable:this force_cast
    }
    public func doGroup(groupId: String, traits: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return self.runDo(runNext: {
            return self.nextWorker?.doGroup(groupId: groupId, traits: traits, options: options)
        },
        doWork: {
            return self.intDoGroup(groupId: groupId, traits: traits, options: options, then: $0)
        }) as! WKRPTCLAnalyticsResVoid // swiftlint:disable:this force_cast
    }
    public func doIdentify(userId: String, traits: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return self.runDo(runNext: {
            return self.nextWorker?.doIdentify(userId: userId, traits: traits, options: options)
        },
        doWork: {
            return self.intDoIdentify(userId: userId, traits: traits, options: options, then: $0)
        }) as! WKRPTCLAnalyticsResVoid // swiftlint:disable:this force_cast
    }
    public func doScreen(screenTitle: String, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return self.runDo(runNext: {
            return self.nextWorker?.doScreen(screenTitle: screenTitle, properties: properties, options: options)
        },
        doWork: {
            return self.intDoScreen(screenTitle: screenTitle, properties: properties, options: options, then: $0)
        }) as! WKRPTCLAnalyticsResVoid // swiftlint:disable:this force_cast
    }
    public func doTrack(event: WKRPTCLAnalyticsEvents, properties: DNSDataDictionary = [:], options: DNSDataDictionary = [:]) -> WKRPTCLAnalyticsResVoid {
        return self.runDo(runNext: {
            return self.nextWorker?.doTrack(event: event, properties: properties, options: options)
        },
        doWork: {
            return self.intDoTrack(event: event, properties: properties, options: options, then: $0)
        }) as! WKRPTCLAnalyticsResVoid // swiftlint:disable:this force_cast
    }

    // MARK: - Shortcuts -
    open func doAutoTrack(class: String, method: String) -> WKRPTCLAnalyticsResVoid {
        return self.doAutoTrack(class: `class`, method: method, properties: DNSDataDictionary.empty, options: DNSDataDictionary.empty)
    }
    open func doAutoTrack(class: String, method: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return self.doAutoTrack(class: `class`, method: method, properties: properties, options: DNSDataDictionary.empty)
    }
    open func doGroup(groupId: String) -> WKRPTCLAnalyticsResVoid {
        return self.doGroup(groupId: groupId, traits: DNSDataDictionary.empty, options: DNSDataDictionary.empty)
    }
    open func doGroup(groupId: String, traits: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return self.doGroup(groupId: groupId, traits: traits, options: DNSDataDictionary.empty)
    }
    open func doIdentify(userId: String) -> WKRPTCLAnalyticsResVoid {
        return self.doIdentify(userId: userId, traits: DNSDataDictionary.empty, options: DNSDataDictionary.empty)
    }
    open func doIdentify(userId: String, traits: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return self.doIdentify(userId: userId, traits: traits, options: DNSDataDictionary.empty)
    }
    open func doScreen(screenTitle: String) -> WKRPTCLAnalyticsResVoid {
        return self.doScreen(screenTitle: screenTitle, properties: DNSDataDictionary.empty, options: DNSDataDictionary.empty)
    }
    open func doScreen(screenTitle: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return self.doScreen(screenTitle: screenTitle, properties: properties, options: DNSDataDictionary.empty)
    }
    open func doTrack(event: WKRPTCLAnalyticsEvents) -> WKRPTCLAnalyticsResVoid {
        return self.doTrack(event: event, properties: DNSDataDictionary.empty, options: DNSDataDictionary.empty)
    }
    open func doTrack(event: WKRPTCLAnalyticsEvents, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return self.doTrack(event: event, properties: properties, options: DNSDataDictionary.empty)
    }

    // MARK: - Internal Work Methods
    open func intDoAutoTrack(class: String, method: String, properties: DNSDataDictionary, options: DNSDataDictionary,
                             then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        _ = resultBlock?(.unhandled)
        return .success
    }
    open func intDoGroup(groupId: String, traits: DNSDataDictionary, options: DNSDataDictionary,
                         then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        _ = resultBlock?(.unhandled)
        return .success
    }
    open func intDoIdentify(userId: String, traits: DNSDataDictionary, options: DNSDataDictionary,
                            then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        _ = resultBlock?(.unhandled)
        return .success
    }
    open func intDoScreen(screenTitle: String, properties: DNSDataDictionary, options: DNSDataDictionary,
                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        _ = resultBlock?(.unhandled)
        return .success
    }
    open func intDoTrack(event: WKRPTCLAnalyticsEvents, properties: DNSDataDictionary = [:], options: DNSDataDictionary = [:],
                         then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        _ = resultBlock?(.unhandled)
        return .success
    }
}
