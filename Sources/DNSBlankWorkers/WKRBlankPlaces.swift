//
//  WKRBlankPlaces.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSDataObjects
import DNSError
import DNSProtocols

open class WKRBlankPlaces: WKRBlankBase, WKRPTCLPlaces {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLPlaces?

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
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
                      doWork: DNSPTCLCallResultBlock = { return $0?(.unhandled) }) -> Any? {
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    @discardableResult
    public func runDoPub(runNext: DNSPTCLCallBlock?,
                         doWork: DNSPTCLCallResultBlock = { return $0?(.unhandled) }) -> Any? {
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Places.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doFilterPlaces(for activity: DAOActivity,
                                using places: [DAOPlace],
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLPlacesBlkAPlace?) {
        self.runDo(runNext: {
            return self.nextWorker?.doFilterPlaces(for: activity, using: places, with: progress, and: block)
        },
        doWork: {
            return self.intDoFilterPlaces(for: activity, using: places, with: progress, and: block, then: $0)
        })
    }
    public func doLoadHolidays(for place: DAOPlace,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLPlacesBlkAPlaceHoliday?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadHolidays(for: place, with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadHolidays(for: place, with: progress, and: block, then: $0)
        })
    }
    public func doLoadHours(for place: DAOPlace,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLPlacesBlkPlaceHours?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadHours(for: place, with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadHours(for: place, with: progress, and: block, then: $0)
        })
    }
    public func doLoadPlace(for placeCode: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLPlacesBlkPlace?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadPlace(for: placeCode, with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadPlace(for: placeCode, with: progress, and: block, then: $0)
        })
    }
    public func doLoadPlaces(with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLPlacesBlkAPlace?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadPlaces(with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadPlaces(with: progress, and: block, then: $0)
        })
    }
    public func doLoadPlaces(for account: DAOAccount,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLPlacesBlkAPlace?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadPlaces(for: account, with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadPlaces(for: account, with: progress, and: block, then: $0)
        })
    }
    public func doLoadPlaces(for section: DAOSection,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLPlacesBlkAPlace?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadPlaces(for: section, with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadPlaces(for: section, with: progress, and: block, then: $0)
        })
    }
    public func doLoadState(for place: DAOPlace,
                            with progress: DNSPTCLProgressBlock?) -> WKRPTCLPlacesPubAlertEventStatus {
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLPlacesFutAlertEventStatus { $0(.success(([], [], []))) }.eraseToAnyPublisher()
            }
            return nextWorker.doLoadState(for: place, with: progress)
        },
        doWork: {
            return self.intDoLoadState(for: place, with: progress, then: $0)
        }) as! WKRPTCLPlacesPubAlertEventStatus // swiftlint:disable:this force_cast
    }
    public func doSearchPlace(for geohash: String,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLPlacesBlkPlace?) {
        self.runDo(runNext: {
            return self.nextWorker?.doSearchPlace(for: geohash, with: progress, and: block)
        },
        doWork: {
            return self.intDoSearchPlace(for: geohash, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPlacesBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(place, with: progress, and: block)
        },
        doWork: {
            return self.intDoUpdate(place, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ hours: DAOPlaceHours,
                         for place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPlacesBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(hours, for: place, with: progress, and: block)
        },
        doWork: {
            return self.intDoUpdate(hours, for: place, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doFilterPlaces(for activity: DAOActivity,
                                using places: [DAOPlace],
                                with block: WKRPTCLPlacesBlkAPlace?) {
        self.doFilterPlaces(for: activity, using: places, with: nil, and: block)
    }
    public func doLoadHolidays(for place: DAOPlace,
                               with block: WKRPTCLPlacesBlkAPlaceHoliday?) {
        self.doLoadHolidays(for: place, with: nil, and: block)
    }
    public func doLoadHours(for place: DAOPlace,
                            with block: WKRPTCLPlacesBlkPlaceHours?) {
        self.doLoadHours(for: place, with: nil, and: block)
    }
    public func doLoadPlace(for placeCode: String,
                             with block: WKRPTCLPlacesBlkPlace?) {
        self.doLoadPlace(for: placeCode, with: nil, and: block)
    }
    public func doLoadPlaces(with block: WKRPTCLPlacesBlkAPlace?) {
        self.doLoadPlaces(with: nil, and: block)
    }
    public func doLoadPlaces(for account: DAOAccount,
                             with block: WKRPTCLPlacesBlkAPlace?) {
        self.doLoadPlaces(for: account, with: nil, and: block)
    }
    public func doLoadPlaces(for section: DAOSection,
                             with block: WKRPTCLPlacesBlkAPlace?) {
        self.doLoadPlaces(for: section, with: nil, and: block)
    }
    public func doLoadState(for place: DAOPlace) -> WKRPTCLPlacesPubAlertEventStatus {
        return self.doLoadState(for: place, with: nil)
    }
    public func doSearchPlace(for geohash: String,
                               with block: WKRPTCLPlacesBlkPlace?) {
        self.doSearchPlace(for: geohash, with: nil, and: block)
    }
    public func doUpdate(_ place: DAOPlace,
                         with block: WKRPTCLPlacesBlkVoid?)  {
        self.doUpdate(place, with: nil, and: block)
    }
    public func doUpdate(_ hours: DAOPlaceHours,
                         for place: DAOPlace,
                         with block: WKRPTCLPlacesBlkVoid?) {
        self.doUpdate(hours, for: place, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoFilterPlaces(for activity: DAOActivity,
                                 using places: [DAOPlace],
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLPlacesBlkAPlace?,
                                 then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadHolidays(for place: DAOPlace,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLPlacesBlkAPlaceHoliday?,
                                then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadHours(for place: DAOPlace,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLPlacesBlkPlaceHours?,
                             then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadPlace(for placeCode: String,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLPlacesBlkPlace?,
                              then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadPlaces(with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLPlacesBlkAPlace?,
                               then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadPlaces(for account: DAOAccount,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLPlacesBlkAPlace?,
                              then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadPlaces(for section: DAOSection,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLPlacesBlkAPlace?,
                              then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadState(for place: DAOPlace,
                             with progress: DNSPTCLProgressBlock?,
                             then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLPlacesPubAlertEventStatus {
        return resultBlock?(.unhandled) as! WKRPTCLPlacesPubAlertEventStatus // swiftlint:disable:this force_cast
    }
    open func intDoSearchPlace(for geohash: String,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLPlacesBlkPlace?,
                                then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPlacesBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ hours: DAOPlaceHours,
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPlacesBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
