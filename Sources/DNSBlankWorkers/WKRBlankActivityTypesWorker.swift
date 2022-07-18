//
//  WKRBlankActivityTypesWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSProtocols
import Foundation

open class WKRBlankActivityTypesWorker: WKRBlankBaseWorker, WKRPTCLActivityTypes {
    public var callNextWhen: WKRPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLActivityTypes?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLActivityTypes,
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
    public func doFavorite(_ activityType: DAOActivityType,
                           for user: DAOUser,
                           with progress: WKRPTCLProgressBlock?,
                           and block: WKRPTCLActivityTypesBlockVoid?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doFavorite(activityType, for: user, with: progress, and: block)
        },
        doWork: {
            return try self.intDoFavorite(activityType, for: user, with: progress, and: block, then: $0)
        })
    }
    public func doIsFavorited(_ activityType: DAOActivityType,
                              for user: DAOUser,
                              with progress: WKRPTCLProgressBlock?,
                              and block: WKRPTCLActivityTypesBlockBool?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doIsFavorited(activityType, for: user, with: progress, and: block)
        },
        doWork: {
            return try self.intDoIsFavorited(activityType, for: user, with: progress, and: block, then: $0)
        })
    }
    public func doLoadActivityType(for code: String,
                                   with progress: WKRPTCLProgressBlock?,
                                   and block: WKRPTCLActivityTypesBlockActivityType?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadActivityType(for: code, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadActivityType(for: code, with: progress, and: block, then: $0)
        })
    }
    public func doLoadActivityTypes(with progress: WKRPTCLProgressBlock?,
                                    and block: WKRPTCLActivityTypesBlockArrayActivityType?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadActivityTypes(with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadActivityTypes(with: progress, and: block, then: $0)
        })
    }
    public func doUnfavorite(_ activityType: DAOActivityType,
                             for user: DAOUser,
                             with progress: WKRPTCLProgressBlock?,
                             and block: WKRPTCLActivityTypesBlockVoid?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doUnfavorite(activityType, for: user, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUnfavorite(activityType, for: user, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ activityType: DAOActivityType,
                         with progress: WKRPTCLProgressBlock?,
                         and block: WKRPTCLActivityTypesBlockBool?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doUpdate(activityType, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(activityType, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Internal Work Methods
    open func intDoLoadAccount(for user: DAOUser,
                               with progress: WKRPTCLProgressBlock?,
                               and block: WKRPTCLAccountBlockAccount?,
                               then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoFavorite(_ activityType: DAOActivityType,
                    for user: DAOUser,
                    with progress: WKRPTCLProgressBlock?,
                    and block: WKRPTCLActivityTypesBlockVoid?,
                            then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoIsFavorited(_ activityType: DAOActivityType,
                       for user: DAOUser,
                       with progress: WKRPTCLProgressBlock?,
                       and block: WKRPTCLActivityTypesBlockBool?,
                               then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadActivityType(for code: String,
                            with progress: WKRPTCLProgressBlock?,
                            and block: WKRPTCLActivityTypesBlockActivityType?,
                                    then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadActivityTypes(with progress: WKRPTCLProgressBlock?,
                             and block: WKRPTCLActivityTypesBlockArrayActivityType?,
                                     then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUnfavorite(_ activityType: DAOActivityType,
                      for user: DAOUser,
                      with progress: WKRPTCLProgressBlock?,
                      and block: WKRPTCLActivityTypesBlockVoid?,
                              then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ activityType: DAOActivityType,
                  with progress: WKRPTCLProgressBlock?,
                  and block: WKRPTCLActivityTypesBlockBool?,
                          then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
