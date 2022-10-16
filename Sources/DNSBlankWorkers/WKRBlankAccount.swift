//
//  WKRBlankAccount.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankAccount: WKRBlankBase, WKRPTCLAccount {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAccount?

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLAccount,
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
        if case DNSError.Account.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doActivate(account: DAOAccount,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLAccountBlkBool?) {
        self.runDo(runNext: {
            return self.nextWorker?.doActivate(account: account, with: progress, and: block)
        },
        doWork: {
            return self.intDoActivate(account: account, with: progress, and: block, then: $0)
        })
    }
    public func doDeactivate(account: DAOAccount,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doDeactivate(account: account, with: progress, and: block)
        },
        doWork: {
            return self.intDoDeactivate(account: account, with: progress, and: block, then: $0)
        })
    }
    public func doDelete(account: DAOAccount,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doDelete(account: account, with: progress, and: block)
        },
        doWork: {
            return self.intDoDelete(account: account, with: progress, and: block, then: $0)
        })
    }
    public func doLoadAccount(for id: String,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLAccountBlkAccount?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadAccount(for: id, with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadAccount(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadAccounts(for user: DAOUser,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLAccountBlkAAccount?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadAccounts(for: user, with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadAccounts(for: user, with: progress, and: block, then: $0)
        })
    }
    public func doLoadCurrentAccounts(with progress: DNSPTCLProgressBlock?,
                                      and block: WKRPTCLAccountBlkAAccount?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadCurrentAccounts(with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadCurrentAccounts(with: progress, and: block, then: $0)
        })
    }
    public func doSearchAccount(using parameters: DNSDataDictionary,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLAccountBlkAAccount?) {
        self.runDo(runNext: {
            return self.nextWorker?.doSearchAccount(using: parameters, with: progress, and: block)
        },
        doWork: {
            return self.intDoSearchAccount(using: parameters, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(account: DAOAccount,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(account: account, with: progress, and: block)
        },
        doWork: {
            return self.intDoUpdate(account: account, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doActivate(account: DAOAccount,
                           and block: WKRPTCLAccountBlkBool?) {
        self.runDo(runNext: {
            return self.nextWorker?.doActivate(account: account, with: nil, and: block)
        },
        doWork: {
            return self.intDoActivate(account: account, with: nil, and: block, then: $0)
        })
    }
    public func doDeactivate(account: DAOAccount,
                             and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doDeactivate(account: account, with: nil, and: block)
        },
        doWork: {
            return self.intDoDeactivate(account: account, with: nil, and: block, then: $0)
        })
    }
    public func doDelete(account: DAOAccount,
                         and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doDelete(account: account, with: nil, and: block)
        },
        doWork: {
            return self.intDoDelete(account: account, with: nil, and: block, then: $0)
        })
    }
    public func doLoadAccount(for id: String,
                              with block: WKRPTCLAccountBlkAccount?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadAccount(for: id, with: nil, and: block)
        },
        doWork: {
            return self.intDoLoadAccount(for: id, with: nil, and: block, then: $0)
        })
    }
    public func doLoadAccounts(for user: DAOUser,
                               with block: WKRPTCLAccountBlkAAccount?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadAccounts(for: user, with: nil, and: block)
        },
        doWork: {
            return self.intDoLoadAccounts(for: user, with: nil, and: block, then: $0)
        })
    }
    public func doLoadCurrentAccounts(with block: WKRPTCLAccountBlkAAccount?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadCurrentAccounts(with: nil, and: block)
        },
        doWork: {
            return self.intDoLoadCurrentAccounts(with: nil, and: block, then: $0)
        })
    }
    public func doSearchAccount(using parameters: DNSDataDictionary,
                                with block: WKRPTCLAccountBlkAAccount?) {
        self.doSearchAccount(using: parameters, with: nil, and: block)
    }
    public func doUpdate(account: DAOAccount,
                         with block: WKRPTCLAccountBlkVoid?) {
        self.doUpdate(account: account, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoActivate(account: DAOAccount,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLAccountBlkBool?,
                            then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoDeactivate(account: DAOAccount,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLAccountBlkVoid?,
                              then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoDelete(account: DAOAccount,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAccountBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadAccount(for id: String,
                               with progress: DNSProtocols.DNSPTCLProgressBlock?,
                               and block: WKRPTCLAccountBlkAccount?,
                               then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadAccounts(for user: DAOUser,
                                with progress: DNSProtocols.DNSPTCLProgressBlock?,
                                and block: WKRPTCLAccountBlkAAccount?,
                                then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadCurrentAccounts(with progress: DNSPTCLProgressBlock?,
                                       and block: WKRPTCLAccountBlkAAccount?,
                                       then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoSearchAccount(using parameters: DNSDataDictionary,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLAccountBlkAAccount?,
                                 then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(account: DAOAccount,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAccountBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
