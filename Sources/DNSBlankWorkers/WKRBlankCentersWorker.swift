//
//  WKRBlankCentersWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSDataObjects
import DNSProtocols

open class WKRBlankCentersWorker: WKRBlankBaseWorker, WKRPTCLCenters {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLCenters?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLCenters,
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
    @discardableResult
    public func runDoPub(runNext: DNSPTCLCallBlock?,
                         doWork: DNSPTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doFilterCenters(for activity: DAOActivity,
                                using centers: [DAOCenter],
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLCentersBlkACenter?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doFilterCenters(for: activity, using: centers, with: progress, and: block)
        },
        doWork: {
            return try self.intDoFilterCenters(for: activity, using: centers, with: progress, and: block, then: $0)
        })
    }
    public func doLoadCenter(for centerCode: String,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCentersBlkCenter?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadCenter(for: centerCode, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadCenter(for: centerCode, with: progress, and: block, then: $0)
        })
    }
    public func doLoadCenters(with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLCentersBlkACenter?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadCenters(with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadCenters(with: progress, and: block, then: $0)
        })
    }
    public func doLoadHolidays(for center: DAOCenter,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLCentersBlkACenterHoliday?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadHolidays(for: center, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadHolidays(for: center, with: progress, and: block, then: $0)
        })
    }
    public func doLoadHours(for center: DAOCenter,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCentersBlkCenterHours?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadHours(for: center, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadHours(for: center, with: progress, and: block, then: $0)
        })
    }
    public func doLoadState(for center: DAOCenter,
                            with progress: DNSPTCLProgressBlock?) -> WKRPTCLCentersPubAlertEventStatus {
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<WKRPTCLCentersRtnAlertEventStatus, Error> { $0(.success(([], [], []))) }.eraseToAnyPublisher()
            }
            return (WKRPTCLCentersPubAlertEventStatus)(nextWorker.doLoadState(for: center, with: progress))
        },
        doWork: {
            return (WKRPTCLCentersPubAlertEventStatus)(self.intDoLoadState(for: center, with: progress, then: $0))
        }) as! WKRPTCLCentersPubAlertEventStatus
    }
    public func doSearchCenter(for geohash: String,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLCentersBlkCenter?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doSearchCenter(for: geohash, with: progress, and: block)
        },
        doWork: {
            return try self.intDoSearchCenter(for: geohash, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ center: DAOCenter,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCentersBlkBool?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doUpdate(center, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(center, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ hours: DAOCenterHours,
                         for center: DAOCenter,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCentersBlkBool?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doUpdate(hours, for: center, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(hours, for: center, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doFilterCenters(for activity: DAOActivity,
                                using centers: [DAOCenter],
                                with block: WKRPTCLCentersBlkACenter?) throws {
        try self.doFilterCenters(for: activity, using: centers, with: nil, and: block)
    }
    public func doLoadCenter(for centerCode: String,
                             with block: WKRPTCLCentersBlkCenter?) throws {
        try self.doLoadCenter(for: centerCode, with: nil, and: block)
    }
    public func doLoadCenters(with block: WKRPTCLCentersBlkACenter?) throws {
        try self.doLoadCenters(with: nil, and: block)
    }
    public func doLoadHolidays(for center: DAOCenter,
                               with block: WKRPTCLCentersBlkACenterHoliday?) throws {
        try self.doLoadHolidays(for: center, with: nil, and: block)
    }
    public func doLoadHours(for center: DAOCenter,
                            with block: WKRPTCLCentersBlkCenterHours?) throws {
        try self.doLoadHours(for: center, with: nil, and: block)
    }
    public func doLoadState(for center: DAOCenter) -> WKRPTCLCentersPubAlertEventStatus {
        return self.doLoadState(for: center, with: nil)
    }
    public func doSearchCenter(for geohash: String,
                               with block: WKRPTCLCentersBlkCenter?) throws {
        try self.doSearchCenter(for: geohash, with: nil, and: block)
    }
    public func doUpdate(_ center: DAOCenter,
                         with block: WKRPTCLCentersBlkBool?) throws {
        try self.doUpdate(center, with: nil, and: block)
    }
    public func doUpdate(_ hours: DAOCenterHours,
                         for center: DAOCenter,
                         with block: WKRPTCLCentersBlkBool?) throws {
        try self.doUpdate(hours, for: center, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoFilterCenters(for activity: DAOActivity,
                                 using centers: [DAOCenter],
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLCentersBlkACenter?,
                                 then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadCenter(for centerCode: String,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLCentersBlkCenter?,
                              then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadCenters(with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLCentersBlkACenter?,
                               then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadHolidays(for center: DAOCenter,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLCentersBlkACenterHoliday?,
                                then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadHours(for center: DAOCenter,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCentersBlkCenterHours?,
                             then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadState(for center: DAOCenter,
                             with progress: DNSPTCLProgressBlock?,
                             then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCentersPubAlertEventStatus {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! WKRPTCLCentersPubAlertEventStatus
    }
    open func intDoSearchCenter(for geohash: String,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLCentersBlkCenter?,
                                then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ center: DAOCenter,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLCentersBlkBool?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ hours: DAOCenterHours,
                          for center: DAOCenter,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLCentersBlkBool?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
