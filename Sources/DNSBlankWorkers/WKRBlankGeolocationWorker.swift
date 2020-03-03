//
//  WKRBlankGeolocationWorker.swift
//  DoubleNode Core - DNSBlankWorkers
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankGeolocationWorker: WKRBlankBaseWorker, PTCLGeolocation_Protocol
{
    public var nextWorker: PTCLGeolocation_Protocol?

    public required init() {
        super.init()
    }

    public required init(nextWorker: PTCLGeolocation_Protocol) {
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

    open func doLocate(with progress: PTCLProgressBlock?,
                       and block: PTCLGeolocationBlockVoidStringDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doLocate(with: progress, and: block)
    }

    open func doTrackLocation(for processKey: String,
                              with progress: PTCLProgressBlock?,
                              and block: PTCLGeolocationBlockVoidStringDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doTrackLocation(for: processKey,
                                        with: progress,
                                        and: block)
    }

    open func doStopTrackLocation(for processKey: String) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doStopTrackLocation(for: processKey)
    }
}
