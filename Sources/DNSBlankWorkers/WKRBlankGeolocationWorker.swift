//
//  WKRBlankGeolocationWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankGeolocationWorker: WKRBlankBaseWorker, WKRPTCLGeolocation {
    public var callNextWhen: WKRPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLGeolocation?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLGeolocation,
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
    public func doLocate(with progress: WKRPTCLProgressBlock?,
                         and block: WKRPTCLGeolocationBlockString?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLocate(with: progress, and: block)
        },
        doWork: {
            return try self.intDoLocate(with: progress, and: block, then: $0)
        })
    }
    public func doTrackLocation(for processKey: String,
                                with progress: WKRPTCLProgressBlock?,
                                and block: WKRPTCLGeolocationBlockString?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doTrackLocation(for: processKey, with: progress, and: block)
        },
        doWork: {
            return try self.intDoTrackLocation(for: processKey, with: progress, and: block, then: $0)
        })
    }
    public func doStopTrackLocation(for processKey: String) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doStopTrackLocation(for: processKey)
        },
        doWork: {
            return try self.intDoStopTrackLocation(for: processKey, then: $0)
        })
    }

    // MARK: - Internal Work Methods
    open func intDoLocate(with progress: WKRPTCLProgressBlock?,
                          and block: WKRPTCLGeolocationBlockString?,
                          then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoTrackLocation(for processKey: String,
                                 with progress: WKRPTCLProgressBlock?,
                                 and block: WKRPTCLGeolocationBlockString?,
                                 then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoStopTrackLocation(for processKey: String,
                                     then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
