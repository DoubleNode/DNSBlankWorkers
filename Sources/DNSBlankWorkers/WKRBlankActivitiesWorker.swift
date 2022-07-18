//
//  WKRBlankActivitiesWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSProtocols
import Foundation

open class WKRBlankActivitiesWorker: WKRBlankBaseWorker, WKRPTCLActivities {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLActivities?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLActivities,
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
    public func doLoadActivities(for center: DAOCenter,
                                 using activityTypes: [DAOActivityType],
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLActivitiesBlockArrayActivity?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadActivities(for: center, using: activityTypes, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadActivities(for: center, using: activityTypes, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ activities: [DAOActivity],
                         for center: DAOCenter,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLActivitiesBlockBool?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doUpdate(activities, for: center, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(activities, for: center, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadActivities(for center: DAOCenter,
                                 using activityTypes: [DAOActivityType],
                                 with block: WKRPTCLActivitiesBlockArrayActivity?) throws {
        try self.doLoadActivities(for: center, using: activityTypes, with: nil, and: block)
    }
    public func doUpdate(_ activities: [DAOActivity],
                         for center: DAOCenter,
                         with block: WKRPTCLActivitiesBlockBool?) throws {
        try self.doUpdate(activities, for: center, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadActivities(for center: DAOCenter,
                                  using activityTypes: [DAOActivityType],
                                  with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLActivitiesBlockArrayActivity?,
                                  then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ activities: [DAOActivity],
                          for center: DAOCenter,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLActivitiesBlockBool?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
