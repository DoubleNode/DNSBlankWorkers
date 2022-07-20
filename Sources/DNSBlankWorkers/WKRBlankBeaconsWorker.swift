//
//  WKRBlankBeaconsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSProtocols
import Foundation

open class WKRBlankBeaconsWorker: WKRBlankBaseWorker, WKRPTCLBeacons {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLBeacons?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLBeacons,
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
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadBeacons(in center: DAOCenter,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLBeaconsBlkABeacon?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadBeacons(in: center, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadBeacons(in: center, with: progress, and: block, then: $0)
        })
    }
    public func doLoadBeacons(in center: DAOCenter,
                              for activity: DAOActivity,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLBeaconsBlkABeacon?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadBeacons(in: center, for: activity,
                                                      with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadBeacons(in: center, for: activity,
                                             with: progress, and: block, then: $0)
        })
    }
    public func doRangeBeacons(named uuids: [UUID],
                               for processKey: String,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLBeaconsBlkABeacon?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doRangeBeacons(named: uuids, for: processKey,
                                                 with: progress, and: block)
        },
        doWork: {
            return try self.intDoRangeBeacons(named: uuids, for: processKey,
                                              with: progress, and: block, then: $0)
        })
    }
    public func doStopRangeBeacons(for processKey: String) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doStopRangeBeacons(for: processKey)
        },
        doWork: {
            return try self.intDoStopRangeBeacons(for: processKey, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadBeacons(in center: DAOCenter,
                              with block: WKRPTCLBeaconsBlkABeacon?) throws {
        try self.doLoadBeacons(in: center, with: nil, and: block)
    }
    public func doLoadBeacons(in center: DAOCenter,
                              for activity: DAOActivity,
                              with block: WKRPTCLBeaconsBlkABeacon?) throws {
        try self.doLoadBeacons(in: center, for: activity, with: nil, and: block)
    }
    public func doRangeBeacons(named uuids: [UUID],
                               for processKey: String,
                               with block: WKRPTCLBeaconsBlkABeacon?) throws {
        try self.doRangeBeacons(named: uuids, for: processKey, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadBeacons(in center: DAOCenter,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLBeaconsBlkABeacon?,
                               then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadBeacons(in center: DAOCenter,
                               for activity: DAOActivity,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLBeaconsBlkABeacon?,
                               then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRangeBeacons(named uuids: [UUID],
                                for processKey: String,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLBeaconsBlkABeacon?,
                                then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoStopRangeBeacons(for processKey: String,
                                    then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
