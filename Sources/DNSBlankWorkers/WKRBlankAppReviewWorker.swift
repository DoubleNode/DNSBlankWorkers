//
//  WKRBlankAnalyticsWorker.swift
//  DoubleNode Core - DNSBlankWorkers
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankAppReviewWorker: PTCLAppReview_Protocol
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
    
    open required init() {
    }

    open required init(nextWorker: PTCLAppReview_Protocol) {
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
    
    // MARK: - Business Logic / Single Item CRUD
    open func doReview() throws -> Bool {
        guard nextWorker != nil else {
            throw DNSBlankWorkersError.notImplemented(domain: "com.doublenode.\(type(of: self))",
                file: "\(#file)",
                line: "\(#line)",
                method: "\(#function)")
        }

        return try nextWorker!.doReview()
    }
}
