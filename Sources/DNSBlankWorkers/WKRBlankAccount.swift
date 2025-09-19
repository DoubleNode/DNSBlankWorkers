//
//  WKRBlankAccount.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankAccount: WKRBlankBase, WKRPTCLAccount {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled

    public var nextWKRPTCLAccount: WKRPTCLAccount? {
        get { return nextWorker as? WKRPTCLAccount }
        set { nextWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLAccount,
                         for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.callNextWhen = callNextWhen
        self.nextWKRPTCLAccount = nextWorker
    }

    override open func disableOption(_ option: String) {
        super.disableOption(option)
        nextWKRPTCLAccount?.disableOption(option)
    }
    override open func enableOption(_ option: String) {
        super.enableOption(option)
        nextWKRPTCLAccount?.enableOption(option)
    }
    @discardableResult
    public func runDo(runNext: DNSPTCLCallBlock?,
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWKRPTCLAccount != nil) ? runNext : nil
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
            return self.nextWKRPTCLAccount?.doActivate(account: account, with: progress, and: block)
        },
                   doWork: {
            return self.intDoActivate(account: account, with: progress, and: block, then: $0)
        })
    }
    public func doApprove(linkRequest: DAOAccountLinkRequest,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doApprove(linkRequest: linkRequest, with: progress, and: block)
        },
                   doWork: {
            return self.intDoApprove(linkRequest: linkRequest, with: progress, and: block, then: $0)
        })
    }
    public func doDeactivate(account: DAOAccount,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doDeactivate(account: account, with: progress, and: block)
        },
                   doWork: {
            return self.intDoDeactivate(account: account, with: progress, and: block, then: $0)
        })
    }
    public func doDecline(linkRequest: DAOAccountLinkRequest,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doDecline(linkRequest: linkRequest, with: progress, and: block)
        },
                   doWork: {
            return self.intDoDecline(linkRequest: linkRequest, with: progress, and: block, then: $0)
        })
    }
    public func doDelete(account: DAOAccount,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doDelete(account: account, with: progress, and: block)
        },
                   doWork: {
            return self.intDoDelete(account: account, with: progress, and: block, then: $0)
        })
    }
    public func doLink(account: DAOAccount,
                       to user: DAOUser,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doLink(account: account, to: user, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLink(account: account, to: user, with: progress, and: block, then: $0)
        })
    }
    public func doLink(account: DAOAccount,
                       to place: DAOPlace,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doLink(account: account, to: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLink(account: account, to: place, with: progress, and: block, then: $0)
        })
    }
    public func doLoadAccount(for id: String,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLAccountBlkAccount?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doLoadAccount(for: id, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadAccount(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadAccounts(for place: DAOPlace,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLAccountBlkAAccount?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doLoadAccounts(for: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadAccounts(for: place, with: progress, and: block, then: $0)
        })
    }
    public func doLoadAccounts(for user: DAOUser,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLAccountBlkAAccount?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doLoadAccounts(for: user, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadAccounts(for: user, with: progress, and: block, then: $0)
        })
    }
    public func doLoadCurrentAccounts(with progress: DNSPTCLProgressBlock?,
                                      and block: WKRPTCLAccountBlkAAccount?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doLoadCurrentAccounts(with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadCurrentAccounts(with: progress, and: block, then: $0)
        })
    }
    public func doRename(accountId: String,
                         to newAccountId: String,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doRename(accountId: accountId, to: newAccountId, with: progress, and: block)
        },
                   doWork: {
            return self.intDoRename(accountId: accountId, to: newAccountId, with: progress, and: block, then: $0)
        })
    }
    public func doSearchAccounts(using parameters: DNSDataDictionary,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLAccountBlkAAccount?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doSearchAccounts(using: parameters, with: progress, and: block)
        },
                   doWork: {
            return self.intDoSearchAccounts(using: parameters, with: progress, and: block, then: $0)
        })
    }
    public func doUnlink(account: DAOAccount,
                         from user: DAOUser,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doUnlink(account: account, from: user, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUnlink(account: account, from: user, with: progress, and: block, then: $0)
        })
    }
    public func doUnlink(account: DAOAccount,
                         from place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doUnlink(account: account, from: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUnlink(account: account, from: place, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(account: DAOAccount,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doUpdate(account: account, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(account: account, with: progress, and: block, then: $0)
        })
    }
    public func doVerify(account: DAOAccount,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAccountBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAccount?.doVerify(account: account, with: progress, and: block)
        },
                   doWork: {
            return self.intDoVerify(account: account, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doActivate(account: DAOAccount,
                           and block: WKRPTCLAccountBlkBool?) {
        self.doActivate(account: account, with: nil, and: block)
    }
    public func doApprove(linkRequest: DAOAccountLinkRequest,
                          with block: WKRPTCLAccountBlkVoid?) {
        self.doApprove(linkRequest: linkRequest, with: nil, and: block)
    }
    public func doDeactivate(account: DAOAccount,
                             and block: WKRPTCLAccountBlkVoid?) {
        self.doDeactivate(account: account, with: nil, and: block)
    }
    public func doDecline(linkRequest: DAOAccountLinkRequest,
                          with block: WKRPTCLAccountBlkVoid?) {
        self.doDecline(linkRequest: linkRequest, with: nil, and: block)
    }
    public func doDelete(account: DAOAccount,
                         and block: WKRPTCLAccountBlkVoid?) {
        self.doDelete(account: account, with: nil, and: block)
    }
    public func doLink(account: DAOAccount,
                       to user: DAOUser,
                       with block: WKRPTCLAccountBlkVoid?) {
        self.doLink(account: account, to: user, with: nil, and: block)
    }
    public func doLink(account: DAOAccount,
                       to place: DAOPlace,
                       with block: WKRPTCLAccountBlkVoid?) {
        self.doLink(account: account, to: place, with: nil, and: block)
    }
    public func doLoadAccount(for id: String,
                              with block: WKRPTCLAccountBlkAccount?) {
        self.doLoadAccount(for: id, with: nil, and: block)
    }
    public func doLoadAccounts(for place: DAOPlace,
                               with block: WKRPTCLAccountBlkAAccount?) {
        self.doLoadAccounts(for: place, with: nil, and: block)
    }
    public func doLoadAccounts(for user: DAOUser,
                               with block: WKRPTCLAccountBlkAAccount?) {
        self.doLoadAccounts(for: user, with: nil, and: block)
    }
    public func doLoadCurrentAccounts(with block: WKRPTCLAccountBlkAAccount?) {
        self.doLoadCurrentAccounts(with: nil, and: block)
    }
    public func doRename(accountId: String,
                         to newAccountId: String,
                         with block: WKRPTCLAccountBlkVoid?) {
        self.doRename(accountId: accountId, to: newAccountId, with: nil, and: block)
    }
    public func doSearchAccounts(using parameters: DNSDataDictionary,
                                 with block: WKRPTCLAccountBlkAAccount?) {
        self.doSearchAccounts(using: parameters, with: nil, and: block)
    }
    public func doUnlink(account: DAOAccount,
                         from user: DAOUser,
                         with block: WKRPTCLAccountBlkVoid?) {
        self.doUnlink(account: account, from: user, with: nil, and: block)
    }
    public func doUnlink(account: DAOAccount,
                         from place: DAOPlace,
                         with block: WKRPTCLAccountBlkVoid?) {
        self.doUnlink(account: account, from: place, with: nil, and: block)
    }
    public func doUpdate(account: DAOAccount,
                         with block: WKRPTCLAccountBlkVoid?) {
        self.doUpdate(account: account, with: nil, and: block)
    }
    public func doVerify(account: DAOAccount,
                         with block: WKRPTCLAccountBlkVoid?) {
        self.doVerify(account: account, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoActivate(account: DAOAccount,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLAccountBlkBool?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(true))
        _ = resultBlock?(.completed)
    }
    open func intDoApprove(linkRequest: DAOAccountLinkRequest,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLAccountBlkVoid?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoDeactivate(account: DAOAccount,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLAccountBlkVoid?,
                              then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoDecline(linkRequest: DAOAccountLinkRequest,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLAccountBlkVoid?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoDelete(account: DAOAccount,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAccountBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoLink(account: DAOAccount,
                        to user: DAOUser,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLAccountBlkVoid?,
                        then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoLink(account: DAOAccount,
                        to place: DAOPlace,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLAccountBlkVoid?,
                        then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoLoadAccount(for id: String,
                               with progress: DNSProtocols.DNSPTCLProgressBlock?,
                               and block: WKRPTCLAccountBlkAccount?,
                               then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOAccount()))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadAccounts(for place: DAOPlace,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLAccountBlkAAccount?,
                                then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadAccounts(for user: DAOUser,
                                with progress: DNSProtocols.DNSPTCLProgressBlock?,
                                and block: WKRPTCLAccountBlkAAccount?,
                                then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadCurrentAccounts(with progress: DNSPTCLProgressBlock?,
                                       and block: WKRPTCLAccountBlkAAccount?,
                                       then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadPlaces(for account: DAOAccount,
                              with progress: DNSProtocols.DNSPTCLProgressBlock?,
                              and block: WKRPTCLAccountBlkAPlace?,
                              then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    open func intDoRename(accountId: String,
                          to newAccountId: String,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAccountBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoSearchAccounts(using parameters: DNSDataDictionary,
                                  with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLAccountBlkAAccount?,
                                  then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    open func intDoUnlink(account: DAOAccount,
                          from user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAccountBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoUnlink(account: DAOAccount,
                          from place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAccountBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoUpdate(account: DAOAccount,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAccountBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoVerify(account: DAOAccount,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAccountBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
