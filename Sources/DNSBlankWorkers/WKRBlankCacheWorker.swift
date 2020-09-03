//
//  WKRBlankAnalyticsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
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
                             and block: PTCLCacheBlockVoidDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doDeleteObject(for: id, with: progress, and:block)
    }

    open func doReadObject(for id: String,
                           with progress: PTCLProgressBlock?,
                           and block: PTCLCacheBlockVoidAnyDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doReadObject(for: id, with: progress, and:block)
    }

    open func doReadObject(for id: String,
                           with progress: PTCLProgressBlock?,
                           and block: PTCLCacheBlockVoidStringDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doReadObject(for: id, with: progress, and:block)
    }

    open func doLoadImage(from url: NSURL,
                          for id: String,
                          with progress: PTCLProgressBlock?,
                          and block: PTCLCacheBlockVoidAnyDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doLoadImage(from: url, for: id, with: progress, and:block)
    }

    open func doUpdate(object: Any,
                       for id: String,
                       with progress: PTCLProgressBlock?,
                       and block: PTCLCacheBlockVoidAnyDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doUpdate(object: object, for: id, with: progress, and:block)
    }
}
