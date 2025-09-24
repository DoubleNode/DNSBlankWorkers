//
//  WKRBaseAnalytics.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSError
import DNSProtocols
import Foundation

open class WKRBaseAnalytics: WKRBaseWorker, WKRPTCLAnalytics {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAnalytics? {
        get { return nextBaseWorker as? WKRPTCLAnalytics }
        set { nextBaseWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
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
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Analytics.notFound = error {
            return .notFound
        }
        return result
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
        return self.doAutoTrack(class: `class`, method: method, properties: .empty, options: .empty)
    }
    open func doAutoTrack(class: String, method: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return self.doAutoTrack(class: `class`, method: method, properties: properties, options: .empty)
    }
    open func doGroup(groupId: String) -> WKRPTCLAnalyticsResVoid {
        return self.doGroup(groupId: groupId, traits: .empty, options: .empty)
    }
    open func doGroup(groupId: String, traits: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return self.doGroup(groupId: groupId, traits: traits, options: .empty)
    }
    open func doIdentify(userId: String) -> WKRPTCLAnalyticsResVoid {
        return self.doIdentify(userId: userId, traits: .empty, options: .empty)
    }
    open func doIdentify(userId: String, traits: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return self.doIdentify(userId: userId, traits: traits, options: .empty)
    }
    open func doScreen(screenTitle: String) -> WKRPTCLAnalyticsResVoid {
        return self.doScreen(screenTitle: screenTitle, properties: .empty, options: .empty)
    }
    open func doScreen(screenTitle: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return self.doScreen(screenTitle: screenTitle, properties: properties, options: .empty)
    }
    open func doTrack(event: WKRPTCLAnalyticsEvents) -> WKRPTCLAnalyticsResVoid {
        return self.doTrack(event: event, properties: .empty, options: .empty)
    }
    open func doTrack(event: WKRPTCLAnalyticsEvents, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return self.doTrack(event: event, properties: properties, options: .empty)
    }

    // MARK: - Internal Work Methods
    open func intDoAutoTrack(class: String, method: String, properties: DNSDataDictionary, options: DNSDataDictionary,
                             then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        return resultBlock?(.unhandled) as! WKRPTCLAnalyticsResVoid // swiftlint:disable:this force_cast
    }
    open func intDoGroup(groupId: String, traits: DNSDataDictionary, options: DNSDataDictionary,
                         then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        return resultBlock?(.unhandled) as! WKRPTCLAnalyticsResVoid // swiftlint:disable:this force_cast
    }
    open func intDoIdentify(userId: String, traits: DNSDataDictionary, options: DNSDataDictionary,
                            then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        return resultBlock?(.unhandled) as! WKRPTCLAnalyticsResVoid // swiftlint:disable:this force_cast
    }
    open func intDoScreen(screenTitle: String, properties: DNSDataDictionary, options: DNSDataDictionary,
                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        return resultBlock?(.unhandled) as! WKRPTCLAnalyticsResVoid // swiftlint:disable:this force_cast
    }
    open func intDoTrack(event: WKRPTCLAnalyticsEvents, properties: DNSDataDictionary = [:], options: DNSDataDictionary = [:],
                         then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        return resultBlock?(.unhandled) as! WKRPTCLAnalyticsResVoid // swiftlint:disable:this force_cast
    }
}
