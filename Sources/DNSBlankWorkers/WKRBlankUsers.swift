//
//  WKRBlankUsers.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import DNSError
import DNSProtocols

open class WKRBlankUsers: WKRBlankBase, WKRPTCLUsers {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLUsers?

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
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
    public func doActivate(_ user: DAOUser,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLUsersBlkBool?) {
        self.runDo(runNext: {
            return self.nextWorker?.doActivate(user, with: progress, and: block)
        },
                   doWork: {
            return self.intDoActivate(user, with: progress, and: block, then: $0)
        })
    }
    public func doConfirm(pendingUser: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLUsersBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doConfirm(pendingUser: pendingUser, with: progress, and: block)
        },
                   doWork: {
            return self.intDoConfirm(pendingUser: pendingUser, with: progress, and: block, then: $0)
        })
    }
    public func doConsent(childUser: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLUsersBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doConsent(childUser: childUser, with: progress, and: block)
        },
                   doWork: {
            return self.intDoConsent(childUser: childUser, with: progress, and: block, then: $0)
        })
    }
    public func doLoadCurrentUser(with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLUsersBlkUser?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadCurrentUser(with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadCurrentUser(with: progress, and: block, then: $0)
        })
    }
    public func doLoadChildUsers(for user: DAOUser,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLUsersBlkAUser?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadChildUsers(for: user, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadChildUsers(for: user, with: progress, and: block, then: $0)
        })
    }
    public func doLoadLinkRequests(for user: DAOUser,
                                   using parameters: DNSDataDictionary,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLUsersBlkAAccountLinkRequest?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadLinkRequests(for: user, using: parameters, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadLinkRequests(for: user, using: parameters, with: progress, and: block, then: $0)
        })
    }
    public func doLoadPendingUsers(for user: DAOUser,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLUsersBlkAUser?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadPendingUsers(for: user, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadPendingUsers(for: user, with: progress, and: block, then: $0)
        })
    }
    public func doLoadUnverifiedAccounts(for user: DAOUser,
                                         with progress: DNSPTCLProgressBlock?,
                                         and block: WKRPTCLUsersBlkAAccount?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadUnverifiedAccounts(for: user, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadUnverifiedAccounts(for: user, with: progress, and: block, then: $0)
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
    public func doReact(with reaction: DNSReactionType,
                        to user: DAOUser,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLUsersBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doReact(with: reaction, to: user, with: progress, and: block)
        },
                   doWork: {
            return self.intDoReact(with: reaction, to: user, with: progress, and: block, then: $0)
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
    public func doUnreact(with reaction: DNSReactionType,
                          to user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLUsersBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUnreact(with: reaction, to: user, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUnreact(with: reaction, to: user, with: progress, and: block, then: $0)
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
    public func doActivate(_ user: DAOUser,
                           with block: WKRPTCLUsersBlkBool?) {
        self.doActivate(user, with: nil, and: block)
    }
    public func doConfirm(pendingUser: DAOUser,
                          with block: WKRPTCLUsersBlkVoid?) {
        self.doConfirm(pendingUser: pendingUser, with: nil, and: block)
    }
    public func doConsent(childUser: DAOUser,
                          with block: WKRPTCLUsersBlkVoid?) {
        self.doConsent(childUser: childUser, with: nil, and: block)
    }
    public func doLoadCurrentUser(with block: WKRPTCLUsersBlkUser?) {
        self.doLoadCurrentUser(with: nil, and: block)
    }
    public func doLoadChildUsers(for user: DAOUser,
                                 with block: WKRPTCLUsersBlkAUser?) {
        self.doLoadChildUsers(for: user, with: nil, and: block)
    }
    public func doLoadLinkRequests(for user: DAOUser,
                                   using parameters: DNSDataDictionary,
                                   with block: WKRPTCLUsersBlkAAccountLinkRequest?) {
        self.doLoadLinkRequests(for: user, using: parameters, with: nil, and: block)
    }
    public func doLoadLinkRequests(for user: DAOUser,
                                   with block: WKRPTCLUsersBlkAAccountLinkRequest?) {
        self.doLoadLinkRequests(for: user, using: .empty, with: nil, and: block)
    }
    public func doLoadPendingUsers(for user: DAOUser,
                                   with block: WKRPTCLUsersBlkAUser?) {
        self.doLoadPendingUsers(for: user, with: nil, and: block)
    }
    public func doLoadUnverifiedAccounts(for user: DAOUser,
                                         with block: WKRPTCLUsersBlkAAccount?) {
        self.doLoadUnverifiedAccounts(for: user, with: nil, and: block)
    }
    public func doLoadUser(for id: String,
                           with block: WKRPTCLUsersBlkUser?) {
        self.doLoadUser(for: id, with: nil, and: block)
    }
    public func doLoadUsers(for account: DAOAccount,
                            with block: WKRPTCLUsersBlkAUser?) {
        self.doLoadUsers(for: account, with: nil, and: block)
    }
    public func doReact(with reaction: DNSReactionType,
                        to user: DAOUser,
                        with block: WKRPTCLUsersBlkMeta?) {
        self.doReact(with: reaction, to: user, with: nil, and: block)
    }
    public func doRemove(_ user: DAOUser,
                         with block: WKRPTCLUsersBlkVoid?) {
        self.doRemove(user, with: nil, and: block)
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to user: DAOUser,
                          with block: WKRPTCLUsersBlkMeta?) {
        self.doUnreact(with: reaction, to: user, with: nil, and: block)
    }
    public func doUpdate(_ user: DAOUser,
                         with block: WKRPTCLUsersBlkVoid?) {
        self.doUpdate(user, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoActivate(_ user: DAOUser,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLUsersBlkBool?,
                            then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoConfirm(pendingUser: DAOUser,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLUsersBlkVoid?,
                           then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoConsent(childUser: DAOUser,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLUsersBlkVoid?,
                           then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadCurrentUser(with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLUsersBlkUser?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadChildUsers(for user: DAOUser,
                                  with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLUsersBlkAUser?,
                                  then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadLinkRequests(for user: DAOUser,
                                    using parameters: DNSDataDictionary,
                                    with progress: DNSProtocols.DNSPTCLProgressBlock?,
                                    and block: WKRPTCLUsersBlkAAccountLinkRequest?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadPendingUsers(for user: DAOUser,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLUsersBlkAUser?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadUnverifiedAccounts(for user: DAOUser,
                                          with progress: DNSPTCLProgressBlock?,
                                          and block: WKRPTCLUsersBlkAAccount?,
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
    open func intDoReact(with reaction: DNSReactionType,
                         to user: DAOUser,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLUsersBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemove(_ user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLUsersBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUnreact(with reaction: DNSReactionType,
                           to user: DAOUser,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLUsersBlkMeta?,
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
