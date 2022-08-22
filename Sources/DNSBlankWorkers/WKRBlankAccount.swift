//
//  WKRBlankAccount.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

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
    public func doLoadAccounts(for user: DAOUser,
                               with progress: DNSProtocols.DNSPTCLProgressBlock?,
                               and block: WKRPTCLAccountBlkAAccount?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadAccounts(for: user, with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadAccounts(for: user, with: progress, and: block, then: $0)
        })
    }
    public func doLoadCurrentAccount(with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLAccountBlkAccount?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadCurrentAccount(with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadCurrentAccount(with: progress, and: block, then: $0)
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
    public func doLoadAccounts(for user: DAOUser,
                               with block: WKRPTCLAccountBlkAAccount?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadAccounts(for: user, with: nil, and: block)
        },
        doWork: {
            return self.intDoLoadAccounts(for: user, with: nil, and: block, then: $0)
        })
    }
    public func doLoadCurrentAccount(with block: WKRPTCLAccountBlkAccount?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadCurrentAccount(with: nil, and: block)
        },
        doWork: {
            return self.intDoLoadCurrentAccount(with: nil, and: block, then: $0)
        })
    }
    public func doUpdate(account: DAOAccount,
                         with block: WKRPTCLAccountBlkVoid?) {
        self.doUpdate(account: account, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadAccounts(for user: DAOUser,
                                with progress: DNSProtocols.DNSPTCLProgressBlock?,
                                and block: WKRPTCLAccountBlkAAccount?,
                                then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadCurrentAccount(with progress: DNSPTCLProgressBlock?,
                                      and block: WKRPTCLAccountBlkAccount?,
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
