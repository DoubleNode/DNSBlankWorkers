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

open class WKRBlankBeaconsWorker: WKRBlankBaseWorker, PTCLBeacons_Protocol
{
    public var callNextWhen: PTCLCallNextWhen = .whenUnhandled
    public var nextWorker: PTCLBeacons_Protocol?

    public required init() {
        super.init()
    }
    public func register(nextWorker: PTCLBeacons_Protocol,
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

    // MARK: - Protocol Interface Methods
    public func doLoadBeacons(in center: DAOCenter,
                              with progress: PTCLProgressBlock?,
                              and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadBeacons(in: center, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadBeacons(in: center, with: progress, and: block, then: $0)
        })
    }
    public func doLoadBeacons(in center: DAOCenter,
                              for activity: DAOActivity,
                              with progress: PTCLProgressBlock?,
                              and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadBeacons(in: center, for: activity, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadBeacons(in: center, for: activity, with: progress, and: block, then: $0)
        })
    }
    public func doRangeBeacons(named uuids: [UUID],
                               for processKey: String,
                               with progress: PTCLProgressBlock?,
                               and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doRangeBeacons(named: uuids, for: processKey, with: progress, and: block)
        },
        doWork: {
            return try self.intDoRangeBeacons(named: uuids, for: processKey, with: progress, and: block, then: $0)
        })
    }
    public func doStopRangeBeacons(for processKey: String) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doStopRangeBeacons(for: processKey)
        },
        doWork: {
            return try self.intDoStopRangeBeacons(for: processKey, then: $0)
        })
    }

    // MARK: - Internal Work Methods
    open func intDoLoadBeacons(in center: DAOCenter,
                               with progress: PTCLProgressBlock?,
                               and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?,
                               then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadBeacons(in center: DAOCenter,
                               for activity: DAOActivity,
                               with progress: PTCLProgressBlock?,
                               and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?,
                               then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRangeBeacons(named uuids: [UUID],
                                for processKey: String,
                                with progress: PTCLProgressBlock?,
                                and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?,
                                then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoStopRangeBeacons(for processKey: String,
                                    then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
