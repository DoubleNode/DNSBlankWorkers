//
//  WKRBlankAppReviewWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
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

    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAppReview?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLAppReview,
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
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.AppReview.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doReview() -> WKRPTCLAppReviewResVoid {
        return self.runDo(runNext: {
            return self.nextWorker?.doReview()
        },
        doWork: {
            return self.intDoReview(then: $0)
        }) as! WKRPTCLAppReviewResVoid // swiftlint:disable:this force_cast
    }

    // MARK: - Internal Work Methods
    open func intDoReview(then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAppReviewResVoid {
        _ = resultBlock?(.unhandled)
        return .success
    }
}
