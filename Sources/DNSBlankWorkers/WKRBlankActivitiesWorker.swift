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
    public var callNextWhen: WKRPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLActivities?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLActivities,
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
    public func doLoadActivities(for center: DAOCenter,
                                 using activityTypes: [DAOActivityType],
                                 with progress: WKRPTCLProgressBlock?,
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
                         with progress: WKRPTCLProgressBlock?,
                         and block: WKRPTCLActivitiesBlockBool?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doUpdate(activities, for: center, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(activities, for: center, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Internal Work Methods
    open func intDoLoadActivities(for center: DAOCenter,
                                  using activityTypes: [DAOActivityType],
                                  with progress: WKRPTCLProgressBlock?,
                                  and block: WKRPTCLActivitiesBlockArrayActivity?,
                                  then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ activities: [DAOActivity],
                          for center: DAOCenter,
                          with progress: WKRPTCLProgressBlock?,
                          and block: WKRPTCLActivitiesBlockBool?,
                          then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
