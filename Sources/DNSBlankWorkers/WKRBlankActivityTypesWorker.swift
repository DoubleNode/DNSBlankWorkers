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
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLActivityTypes?

    public required init() {
        super.init()
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
                      doWork: DNSPTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doFavorite(_ activityType: DAOActivityType,
                           for user: DAOUser,
                           with progress: DNSPTCLProgressBlock?,
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
                              with progress: DNSPTCLProgressBlock?,
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
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLActivityTypesBlockActivityType?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadActivityType(for: code, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadActivityType(for: code, with: progress, and: block, then: $0)
        })
    }
    public func doLoadActivityTypes(with progress: DNSPTCLProgressBlock?,
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
                             with progress: DNSPTCLProgressBlock?,
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
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLActivityTypesBlockBool?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doUpdate(activityType, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(activityType, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doFavorite(_ activityType: DAOActivityType,
                           for user: DAOUser,
                           with block: WKRPTCLActivityTypesBlockVoid?) throws {
        try self.doFavorite(activityType, for: user, with: nil, and: block)
    }
    public func doIsFavorited(_ activityType: DAOActivityType,
                              for user: DAOUser,
                              with block: WKRPTCLActivityTypesBlockBool?) throws {
        try self.doIsFavorited(activityType, for: user, with: nil, and: block)
    }
    public func doLoadActivityType(for code: String,
                                   with block: WKRPTCLActivityTypesBlockActivityType?) throws {
        try self.doLoadActivityType(for: code, with: nil, and: block)
    }
    public func doLoadActivityTypes(with block: WKRPTCLActivityTypesBlockArrayActivityType?) throws {
        try self.doLoadActivityTypes(with: nil, and: block)
    }
    public func doUnfavorite(_ activityType: DAOActivityType,
                             for user: DAOUser,
                             with block: WKRPTCLActivityTypesBlockVoid?) throws {
        try self.doUnfavorite(activityType, for: user, with: nil, and: block)
    }
    public func doUpdate(_ activityType: DAOActivityType,
                         with block: WKRPTCLActivityTypesBlockBool?) throws {
        try self.doUpdate(activityType, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadAccount(for user: DAOUser,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLAccountBlockAccount?,
                               then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoFavorite(_ activityType: DAOActivityType,
                    for user: DAOUser,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLActivityTypesBlockVoid?,
                            then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoIsFavorited(_ activityType: DAOActivityType,
                       for user: DAOUser,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLActivityTypesBlockBool?,
                               then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadActivityType(for code: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLActivityTypesBlockActivityType?,
                                    then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadActivityTypes(with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLActivityTypesBlockArrayActivityType?,
                                     then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUnfavorite(_ activityType: DAOActivityType,
                      for user: DAOUser,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLActivityTypesBlockVoid?,
                              then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ activityType: DAOActivityType,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLActivityTypesBlockBool?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
