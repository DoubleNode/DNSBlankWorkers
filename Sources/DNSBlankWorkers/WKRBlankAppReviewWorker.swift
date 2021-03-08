//
//  WKRBlankAppReviewWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankAppReviewWorker: WKRBlankBaseWorker, PTCLAppReview_Protocol
{
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

    public var nextWorker: PTCLAppReview_Protocol?

    public required init() {
        super.init()
    }

    public required init(nextWorker: PTCLAppReview_Protocol) {
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

    // MARK: - Business Logic / Single Item CRUD

    open func doReview() throws -> Bool {
        guard nextWorker != nil else { return false }
        return try nextWorker!.doReview()
    }
}
