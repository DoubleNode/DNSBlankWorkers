//
//  WKRBlankActivities.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankActivities: WKRBlankBase, WKRPTCLActivities {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLActivities?

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
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
                      doWork: DNSPTCLCallResultBlock = { return $0?(.unhandled) }) -> Any? {
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Activities.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadActivities(for place: DAOPlace,
                                 using activityTypes: [DAOActivityType],
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLActivitiesBlkAActivity?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadActivities(for: place, using: activityTypes,
                                                     with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadActivities(for: place, using: activityTypes,
                                            with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ activities: [DAOActivity],
                         for place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLActivitiesBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(activities, for: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(activities, for: place, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadActivities(for place: DAOPlace,
                                 using activityTypes: [DAOActivityType],
                                 with block: WKRPTCLActivitiesBlkAActivity?) {
        self.doLoadActivities(for: place, using: activityTypes, with: nil, and: block)
    }
    public func doUpdate(_ activities: [DAOActivity],
                         for place: DAOPlace,
                         with block: WKRPTCLActivitiesBlkVoid?) {
        self.doUpdate(activities, for: place, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadActivities(for place: DAOPlace,
                                  using activityTypes: [DAOActivityType],
                                  with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLActivitiesBlkAActivity?,
                                  then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ activities: [DAOActivity],
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLActivitiesBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
