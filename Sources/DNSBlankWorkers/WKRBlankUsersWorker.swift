//
//  WKRBlankUsersWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import DNSError
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
                      doWork: DNSPTCLCallResultBlock = { return $0?(.unhandled) }) -> Any? {
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Users.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadCurrentUser(with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLUsersBlkUser?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadCurrentUser(with: progress, and: block)
        },
                       doWork: {
            return self.intDoLoadCurrentUser(with: progress, and: block, then: $0)
        })
    }
    public func doLoadUser(for id: String,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLUsersBlkUser?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadUser(for: id, with: progress, and: block)
        },
                       doWork: {
            return self.intDoLoadUser(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadUsers(for account: DAOAccount,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLUsersBlkAUser?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadUsers(for: account, with: progress, and: block)
        },
                       doWork: {
            return self.intDoLoadUsers(for: account, with: progress, and: block, then: $0)
        })
    }
    public func doRemoveCurrentUser(with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLUsersBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRemoveCurrentUser(with: progress, and: block)
        },
                       doWork: {
            return self.intDoRemoveCurrentUser(with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ user: DAOUser,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLUsersBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRemove(user, with: progress, and: block)
        },
                       doWork: {
            return self.intDoRemove(user, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ user: DAOUser,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLUsersBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(user, with: progress, and: block)
        },
                       doWork: {
            return self.intDoUpdate(user, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadCurrentUser(with block: WKRPTCLUsersBlkUser?) {
        self.doLoadCurrentUser(with: nil, and: block)
    }
    public func doLoadUser(for id: String,
                           with block: WKRPTCLUsersBlkUser?) {
        self.doLoadUser(for: id, with: nil, and: block)
    }
    public func doLoadUsers(for account: DAOAccount,
                            with block: WKRPTCLUsersBlkAUser?) {
        self.doLoadUsers(for: account, with: nil, and: block)
    }
    public func doRemoveCurrentUser(with block: WKRPTCLUsersBlkVoid?) {
        self.doRemoveCurrentUser(with: nil, and: block)
    }
    public func doRemove(_ user: DAOUser,
                         with block: WKRPTCLUsersBlkVoid?) {
        self.doRemove(user, with: nil, and: block)
    }
    public func doUpdate(_ user: DAOUser,
                         with block: WKRPTCLUsersBlkVoid?) {
        self.doUpdate(user, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadCurrentUser(with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLUsersBlkUser?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadUser(for id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLUsersBlkUser?,
                            then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadUsers(for account: DAOAccount,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLUsersBlkAUser?,
                             then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemoveCurrentUser(with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLUsersBlkVoid?,
                                     then resultBlock: DNSPTCLResultBlock?) {
         _ = resultBlock?(.unhandled)
     }
    open func intDoRemove(_ user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLUsersBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLUsersBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
