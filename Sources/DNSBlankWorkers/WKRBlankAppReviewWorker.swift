//
//  WKRBlankAppReviewWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankAppReviewWorker: WKRBlankBaseWorker, WKRPTCLAppReview {
    public var launchedCount: UInt = 0
    public var launchedFirstTime: Date = Date()
    public var launchedLastTime: Date?
    public var reviewRequestLastTime: Date?

    public var appDidCrashLastRun: Bool = false
    public var daysBeforeReminding: UInt = 0
    public var daysUntilPrompt: UInt = 0
    public var hoursSinceLastLaunch: UInt = 0
    public var usesFrequency: UInt = 0
    public var usesSinceFirstLaunch: UInt = 0
    public var usesUntilPrompt: UInt = 0

    public var callNextWhen: WKRPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAppReview?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLAppReview,
                         for callNextWhen: WKRPTCLWorker.Call.NextWhen) {
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
    public func runDo(runNext: WKRPTCLCallBlock?,
                      doWork: WKRPTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Protocol Interface Methods
    public func doReview() throws -> Bool {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return false }
            return try nextWorker.doReview()
        },
        doWork: {
            return try self.intDoReview(then: $0)
        }) as! Bool
    }

    // MARK: - Internal Work Methods
    open func intDoReview(then resultBlock: WKRPTCLResultBlock?) throws -> Bool {
        return resultBlock?(.unhandled) as! Bool
    }
}
