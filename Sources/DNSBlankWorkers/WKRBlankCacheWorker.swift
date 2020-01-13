//
//  WKRBlankAnalyticsWorker.swift
//  DoubleNode Core - DNSBlankWorkers
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankCacheWorker: WKRBlankBaseWorker, PTCLCache_Protocol
{
    public var nextWorker: PTCLCache_Protocol?

    public required init() {
        super.init()
    }

    public required init(nextWorker: PTCLCache_Protocol) {
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

    open func doDeleteObject(for id: String,
                             with progress: PTCLProgressBlock?,
                             and block: PTCLCacheBlockVoidAnyError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doDeleteObject(for: id, with: progress, and:block)
    }

    open func doReadObject(for id: String,
                           with progress: PTCLProgressBlock?,
                           and block: PTCLCacheBlockVoidAnyError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doReadObject(for: id, with: progress, and:block)
    }

    open func doLoadImage(for url: NSURL,
                          with progress: PTCLProgressBlock?,
                          and block: PTCLCacheBlockVoidAnyError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doLoadImage(for: url, with: progress, and:block)
    }

    open func doUpdateObject(for id: String,
                             with progress: PTCLProgressBlock?,
                             and block: PTCLCacheBlockVoidAnyError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doUpdateObject(for: id, with: progress, and:block)
    }
}
