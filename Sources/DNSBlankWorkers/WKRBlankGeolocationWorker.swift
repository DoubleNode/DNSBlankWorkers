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
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLGeolocation?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLGeolocation,
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
                      doWork: DNSPTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doLocate(with progress: DNSPTCLProgressBlock?,
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
                                with progress: DNSPTCLProgressBlock?,
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

    // MARK: - Worker Logic (Shortcuts) -
    public func doLocate(with block: WKRPTCLGeolocationBlockString?) throws {
        try self.doLocate(with: nil, and: block)
    }
    public func doTrackLocation(for processKey: String,
                                with block: WKRPTCLGeolocationBlockString?) throws {
        try self.doTrackLocation(for: processKey, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLocate(with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLGeolocationBlockString?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoTrackLocation(for processKey: String,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLGeolocationBlockString?,
                                 then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoStopTrackLocation(for processKey: String,
                                     then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
