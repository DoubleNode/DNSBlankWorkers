//
//  WKRBlankPlacesWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSDataObjects
import DNSProtocols

open class WKRBlankPlacesWorker: WKRBlankBaseWorker, WKRPTCLPlaces {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLPlaces?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLPlaces,
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
    public func doFilterPlaces(for activity: DAOActivity,
                                using places: [DAOPlace],
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLPlacesBlkAPlace?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doFilterPlaces(for: activity, using: places, with: progress, and: block)
        },
        doWork: {
            return try self.intDoFilterPlaces(for: activity, using: places, with: progress, and: block, then: $0)
        })
    }
    public func doLoadPlace(for placeCode: String,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLPlacesBlkPlace?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadPlace(for: placeCode, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadPlace(for: placeCode, with: progress, and: block, then: $0)
        })
    }
    public func doLoadPlaces(with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLPlacesBlkAPlace?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadPlaces(with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadPlaces(with: progress, and: block, then: $0)
        })
    }
    public func doLoadHolidays(for place: DAOPlace,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLPlacesBlkAPlaceHoliday?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadHolidays(for: place, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadHolidays(for: place, with: progress, and: block, then: $0)
        })
    }
    public func doLoadHours(for place: DAOPlace,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLPlacesBlkPlaceHours?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadHours(for: place, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadHours(for: place, with: progress, and: block, then: $0)
        })
    }
    public func doLoadState(for place: DAOPlace,
                            with progress: DNSPTCLProgressBlock?) -> WKRPTCLPlacesPubAlertEventStatus {
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<WKRPTCLPlacesRtnAlertEventStatus, Error> { $0(.success(([], [], []))) }.eraseToAnyPublisher()
            }
            return (WKRPTCLPlacesPubAlertEventStatus)(nextWorker.doLoadState(for: place, with: progress))
        },
        doWork: {
            return (WKRPTCLPlacesPubAlertEventStatus)(self.intDoLoadState(for: place, with: progress, then: $0))
        }) as! WKRPTCLPlacesPubAlertEventStatus
    }
    public func doSearchPlace(for geohash: String,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLPlacesBlkPlace?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doSearchPlace(for: geohash, with: progress, and: block)
        },
        doWork: {
            return try self.intDoSearchPlace(for: geohash, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPlacesBlkVoid?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doUpdate(place, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(place, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ hours: DAOPlaceHours,
                         for place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPlacesBlkVoid?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doUpdate(hours, for: place, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(hours, for: place, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doFilterPlaces(for activity: DAOActivity,
                                using places: [DAOPlace],
                                with block: WKRPTCLPlacesBlkAPlace?) throws {
        try self.doFilterPlaces(for: activity, using: places, with: nil, and: block)
    }
    public func doLoadPlace(for placeCode: String,
                             with block: WKRPTCLPlacesBlkPlace?) throws {
        try self.doLoadPlace(for: placeCode, with: nil, and: block)
    }
    public func doLoadPlaces(with block: WKRPTCLPlacesBlkAPlace?) throws {
        try self.doLoadPlaces(with: nil, and: block)
    }
    public func doLoadHolidays(for place: DAOPlace,
                               with block: WKRPTCLPlacesBlkAPlaceHoliday?) throws {
        try self.doLoadHolidays(for: place, with: nil, and: block)
    }
    public func doLoadHours(for place: DAOPlace,
                            with block: WKRPTCLPlacesBlkPlaceHours?) throws {
        try self.doLoadHours(for: place, with: nil, and: block)
    }
    public func doLoadState(for place: DAOPlace) -> WKRPTCLPlacesPubAlertEventStatus {
        return self.doLoadState(for: place, with: nil)
    }
    public func doSearchPlace(for geohash: String,
                               with block: WKRPTCLPlacesBlkPlace?) throws {
        try self.doSearchPlace(for: geohash, with: nil, and: block)
    }
    public func doUpdate(_ place: DAOPlace,
                         with block: WKRPTCLPlacesBlkVoid?) throws {
        try self.doUpdate(place, with: nil, and: block)
    }
    public func doUpdate(_ hours: DAOPlaceHours,
                         for place: DAOPlace,
                         with block: WKRPTCLPlacesBlkVoid?) throws {
        try self.doUpdate(hours, for: place, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoFilterPlaces(for activity: DAOActivity,
                                 using places: [DAOPlace],
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLPlacesBlkAPlace?,
                                 then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadPlace(for placeCode: String,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLPlacesBlkPlace?,
                              then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadPlaces(with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLPlacesBlkAPlace?,
                               then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadHolidays(for place: DAOPlace,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLPlacesBlkAPlaceHoliday?,
                                then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadHours(for place: DAOPlace,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLPlacesBlkPlaceHours?,
                             then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadState(for place: DAOPlace,
                             with progress: DNSPTCLProgressBlock?,
                             then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLPlacesPubAlertEventStatus {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! WKRPTCLPlacesPubAlertEventStatus
    }
    open func intDoSearchPlace(for geohash: String,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLPlacesBlkPlace?,
                                then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPlacesBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ hours: DAOPlaceHours,
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPlacesBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
