//
//  WKRBlankGeolocationWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankGeolocationWorker: WKRBlankBaseWorker, PTCLGeolocation_Protocol
{
    public var callNextWhen: PTCLCallNextWhen = .whenUnhandled
    public var nextWorker: PTCLGeolocation_Protocol?

    public required init() {
        super.init()
    }
    public func register(nextWorker: PTCLGeolocation_Protocol,
                         for callNextWhen: PTCLCallNextWhen) {
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
    public func runDo(runNext: PTCLCallBlock?,
                      doWork: PTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Business Logic / Single Item CRUD

    open func doLocate(with progress: PTCLProgressBlock?,
                       and block: PTCLGeolocationBlockVoidStringDNSError?) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLocate(with: progress, and: block)
        }
    }

    open func doTrackLocation(for processKey: String,
                              with progress: PTCLProgressBlock?,
                              and block: PTCLGeolocationBlockVoidStringDNSError?) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doTrackLocation(for: processKey, with: progress, and: block)
        }
    }

    open func doStopTrackLocation(for processKey: String) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doStopTrackLocation(for: processKey)
        }
    }
}
