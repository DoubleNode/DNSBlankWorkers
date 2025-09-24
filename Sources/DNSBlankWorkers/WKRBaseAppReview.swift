//
//  WKRBlankAppReview.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankAppReview: WKRBlankBase, WKRPTCLAppReview {
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
    public var nextWorker: WKRPTCLAppReview? {
        get { return nextBaseWorker as? WKRPTCLAppReview }
        set { nextBaseWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
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
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
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
            return self.intDoReview(with: nil, and: nil, then: $0)
        }) as! WKRPTCLAppReviewResVoid // swiftlint:disable:this force_cast
    }

    public func doReview(with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAppReviewBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doReview(with: progress, and: block)
        }, doWork: {
            return self.intDoReview(with: progress, and: block, then: $0)
        })
    }

    public func doReview(using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAppReviewBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doReview(using: parameters, with: progress, and: block)
        }, doWork: {
            return self.intDoReview(using: parameters, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doReview(and block: WKRPTCLAppReviewBlkVoid?) {
        self.doReview(with: nil, and: block)
    }

    public func doReview(using parameters: DNSDataDictionary, and block: WKRPTCLAppReviewBlkVoid?) {
        self.doReview(using: parameters, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoReview(with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAppReviewBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAppReviewResVoid {
        return resultBlock?(.unhandled) as! WKRPTCLAppReviewResVoid // swiftlint:disable:this force_cast
    }

    open func intDoReview(using parameters: DNSDataDictionary,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAppReviewBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAppReviewResVoid {
        return resultBlock?(.unhandled) as! WKRPTCLAppReviewResVoid // swiftlint:disable:this force_cast
    }
}
