//
//  WKRBlankActivityTypes.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankActivityTypes: WKRBlankBase, WKRPTCLActivityTypes {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLActivityTypes?

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLActivityTypes,
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
        if case DNSError.ActivityTypes.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doFavorite(_ activityType: DAOActivityType,
                           for user: DAOUser,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLActivityTypesBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doFavorite(activityType, for: user,
                                               with: progress, and: block)
        },
        doWork: {
            return self.intDoFavorite(activityType, for: user,
                                      with: progress, and: block, then: $0)
        })
    }
    public func doIsFavorited(_ activityType: DAOActivityType,
                              for user: DAOUser,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLActivityTypesBlkBool?) {
        self.runDo(runNext: {
            return self.nextWorker?.doIsFavorited(activityType, for: user,
                                                  with: progress, and: block)
        },
        doWork: {
            return self.intDoIsFavorited(activityType, for: user,
                                         with: progress, and: block, then: $0)
        })
    }
    public func doLoadActivityType(for code: String,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLActivityTypesBlkActivityType?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadActivityType(for: code,
                                                       with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadActivityType(for: code,
                                              with: progress, and: block, then: $0)
        })
    }
    public func doLoadActivityTypes(with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLActivityTypesBlkAActivityType?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadActivityTypes(with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadActivityTypes(with: progress, and: block, then: $0)
        })
    }
    public func doUnfavorite(_ activityType: DAOActivityType,
                             for user: DAOUser,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLActivityTypesBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUnfavorite(activityType, for: user,
                                                 with: progress, and: block)
        },
        doWork: {
            return self.intDoUnfavorite(activityType, for: user,
                                        with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ activityType: DAOActivityType,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLActivityTypesBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(activityType, with: progress, and: block)
        },
        doWork: {
            return self.intDoUpdate(activityType, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doFavorite(_ activityType: DAOActivityType,
                           for user: DAOUser,
                           with block: WKRPTCLActivityTypesBlkVoid?) {
        self.doFavorite(activityType, for: user, with: nil, and: block)
    }
    public func doIsFavorited(_ activityType: DAOActivityType,
                              for user: DAOUser,
                              with block: WKRPTCLActivityTypesBlkBool?) {
        self.doIsFavorited(activityType, for: user, with: nil, and: block)
    }
    public func doLoadActivityType(for code: String,
                                   with block: WKRPTCLActivityTypesBlkActivityType?) {
        self.doLoadActivityType(for: code, with: nil, and: block)
    }
    public func doLoadActivityTypes(with block: WKRPTCLActivityTypesBlkAActivityType?) {
        self.doLoadActivityTypes(with: nil, and: block)
    }
    public func doUnfavorite(_ activityType: DAOActivityType,
                             for user: DAOUser,
                             with block: WKRPTCLActivityTypesBlkVoid?) {
        self.doUnfavorite(activityType, for: user, with: nil, and: block)
    }
    public func doUpdate(_ activityType: DAOActivityType,
                         with block: WKRPTCLActivityTypesBlkVoid?) {
        self.doUpdate(activityType, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadAccount(for user: DAOUser,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLAccountBlkAccount?,
                               then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoFavorite(_ activityType: DAOActivityType,
                    for user: DAOUser,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLActivityTypesBlkVoid?,
                            then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoIsFavorited(_ activityType: DAOActivityType,
                       for user: DAOUser,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLActivityTypesBlkBool?,
                               then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadActivityType(for code: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLActivityTypesBlkActivityType?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadActivityTypes(with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLActivityTypesBlkAActivityType?,
                                     then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUnfavorite(_ activityType: DAOActivityType,
                      for user: DAOUser,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLActivityTypesBlkVoid?,
                              then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ activityType: DAOActivityType,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLActivityTypesBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
