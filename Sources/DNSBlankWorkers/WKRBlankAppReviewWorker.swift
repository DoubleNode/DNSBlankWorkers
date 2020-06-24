//
//  WKRBlankAnalyticsWorker.swift
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
    public var daysUntilPrompt: Int = 0
    public var usesUntilPrompt: Int = 0
    public var daysBeforeReminding: Int = 0

    public var nextWorker: PTCLAppReview_Protocol?

    public required init() {
        super.init()
    }

    public required init(nextWorker: PTCLAppReview_Protocol) {
        super.init()
        self.nextWorker = nextWorker
    }

    override open func enableOption(option: String) {
        nextWorker?.enableOption(option: option)
    }

    override open func disableOption(option: String) {
        nextWorker?.disableOption(option: option)
    }

    // MARK: - Business Logic / Single Item CRUD

    open func doReview() throws -> Bool {
        guard nextWorker != nil else {
            return false
        }

        return try nextWorker!.doReview()
    }
}
