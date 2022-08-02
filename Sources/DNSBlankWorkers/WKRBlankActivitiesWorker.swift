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
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadActivities(for place: DAOPlace,
                                 using activityTypes: [DAOActivityType],
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLActivitiesBlkAActivity?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadActivities(for: place, using: activityTypes,
                                                         with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadActivities(for: place, using: activityTypes,
                                                with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ activities: [DAOActivity],
                         for place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLActivitiesBlkVoid?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doUpdate(activities, for: place,
                                                with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(activities, for: place,
                                        with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadActivities(for place: DAOPlace,
                                 using activityTypes: [DAOActivityType],
                                 with block: WKRPTCLActivitiesBlkAActivity?) throws {
        try self.doLoadActivities(for: place, using: activityTypes, with: nil, and: block)
    }
    public func doUpdate(_ activities: [DAOActivity],
                         for place: DAOPlace,
                         with block: WKRPTCLActivitiesBlkVoid?) throws {
        try self.doUpdate(activities, for: place, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadActivities(for place: DAOPlace,
                                  using activityTypes: [DAOActivityType],
                                  with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLActivitiesBlkAActivity?,
                                  then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ activities: [DAOActivity],
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLActivitiesBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
