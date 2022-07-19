//
//  WKRBlankUsersWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import DNSProtocols

open class WKRBlankUsersWorker: WKRBlankBaseWorker, WKRPTCLUsers {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLUsers?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLUsers,
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
    public func doLoadCurrentUser(with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLUsersBlockUser?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadCurrentUser(with: progress, and: block)
        },
                       doWork: {
            return try self.intDoLoadCurrentUser(with: progress, and: block, then: $0)
        })
    }
    public func doLoadUser(for id: String,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLUsersBlockUser?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadUser(for: id, with: progress, and: block)
        },
                       doWork: {
            return try self.intDoLoadUser(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doRemoveCurrentUser(with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLUsersBlockBool?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doRemoveCurrentUser(with: progress, and: block)
        },
                       doWork: {
            return try self.intDoRemoveCurrentUser(with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ user: DAOUser,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLUsersBlockBool?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doRemove(user, with: progress, and: block)
        },
                       doWork: {
            return try self.intDoRemove(user, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ user: DAOUser,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLUsersBlockBool?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doUpdate(user, with: progress, and: block)
        },
                       doWork: {
            return try self.intDoUpdate(user, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadCurrentUser(with block: WKRPTCLUsersBlockUser?) throws {
        try self.doLoadCurrentUser(with: nil, and: block)
    }
    public func doLoadUser(for id: String,
                           with block: WKRPTCLUsersBlockUser?) throws {
        try self.doLoadUser(for: id, with: nil, and: block)
    }
    public func doRemoveCurrentUser(with block: WKRPTCLUsersBlockBool?) throws {
        try self.doRemoveCurrentUser(with: nil, and: block)
    }
    public func doRemove(_ user: DAOUser,
                         with block: WKRPTCLUsersBlockBool?) throws {
        try self.doRemove(user, with: nil, and: block)
    }
    public func doUpdate(_ user: DAOUser,
                         with block: WKRPTCLUsersBlockBool?) throws {
        try self.doUpdate(user, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadCurrentUser(with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLUsersBlockUser?,
                                   then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadUser(for id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLUsersBlockUser?,
                            then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemoveCurrentUser(with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLUsersBlockBool?,
                                     then resultBlock: DNSPTCLResultBlock?) throws {
         _ = resultBlock?(.unhandled)
     }
    open func intDoRemove(_ user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLUsersBlockBool?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLUsersBlockBool?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
