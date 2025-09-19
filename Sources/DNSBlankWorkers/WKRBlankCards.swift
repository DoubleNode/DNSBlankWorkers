//
//  WKRBlankDCards.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankCards: WKRBlankBase, WKRPTCLCards {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled

    public var nextWKRPTCLCards: WKRPTCLCards? {
        get { return nextWorker as? WKRPTCLCards }
        set { nextWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLCards,
                         for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.callNextWhen = callNextWhen
        self.nextWKRPTCLCards = nextWorker
    }

    override open func disableOption(_ option: String) {
        super.disableOption(option)
        nextWKRPTCLCards?.disableOption(option)
    }
    override open func enableOption(_ option: String) {
        super.enableOption(option)
        nextWKRPTCLCards?.enableOption(option)
    }
    @discardableResult
    public func runDo(runNext: DNSPTCLCallBlock?,
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWKRPTCLCards != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Cards.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doAdd(_ card: DAOCard,
                      to user: DAOUser,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLCardsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLCards?.doAdd(card, to: user, with: progress, and: block)
        },
                   doWork: {
            return self.intDoAdd(card, to: user, with: progress, and: block, then: $0)
        })
    }
    public func doLoadCard(for id: String,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLCardsBlkCard?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLCards?.doLoadCard(for: id, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadCard(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadCard(for transaction: DAOTransaction,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLCardsBlkCard?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLCards?.doLoadCard(for: transaction, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadCard(for: transaction, with: progress, and: block, then: $0)
        })
    }
    public func doLoadCards(for user: DAOUser,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCardsBlkACard?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLCards?.doLoadCards(for: user, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadCards(for: user, with: progress, and: block, then: $0)
        })
    }
    public func doLoadTransactions(for card: DAOCard,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLCardsBlkATransaction?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLCards?.doLoadTransactions(for: card, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadTransactions(for: card, with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ card: DAOCard,
                         from user: DAOUser,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCardsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLCards?.doRemove(card, from: user, with: progress, and: block)
        },
                   doWork: {
            return self.intDoRemove(card, from: user, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ card: DAOCard,
                         for user: DAOUser,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCardsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLCards?.doUpdate(card, for: user, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(card, for: user, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doAdd(_ card: DAOCard,
                      to user: DAOUser,
                      with block: WKRPTCLCardsBlkVoid?) {
        self.doAdd(card, to: user, with: nil, and: block)
    }
    public func doLoadCard(for id: String,
                           with block: WKRPTCLCardsBlkCard?) {
        self.doLoadCard(for: id, with: nil, and: block)
    }
    public func doLoadCard(for transaction: DAOTransaction,
                           with block: WKRPTCLCardsBlkCard?) {
        self.doLoadCard(for: transaction, with: nil, and: block)
    }
    public func doLoadCards(for user: DAOUser,
                            with block: WKRPTCLCardsBlkACard?) {
        self.doLoadCards(for: user, with: nil, and: block)
    }
    public func doLoadTransactions(for card: DAOCard,
                                   with block: WKRPTCLCardsBlkATransaction?) {
        self.doLoadTransactions(for: card, with: nil, and: block)
    }
    public func doRemove(_ card: DAOCard,
                         from user: DAOUser,
                         with block: WKRPTCLCardsBlkVoid?) {
        self.doRemove(card, from: user, with: nil, and: block)
    }
    public func doUpdate(_ card: DAOCard,
                         for user: DAOUser,
                         with block: WKRPTCLCardsBlkVoid?) {
        self.doUpdate(card, for: user, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoAdd(_ card: DAOCard,
                       to user: DAOUser,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLCardsBlkVoid?,
                       then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoLoadCard(for id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCardsBlkCard?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOCard()))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadCard(for transaction: DAOTransaction,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCardsBlkCard?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOCard()))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadCards(for user: DAOUser,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCardsBlkACard?,
                             then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadTransactions(for card: DAOCard,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLCardsBlkATransaction?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    open func intDoRemove(_ card: DAOCard,
                          from user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLCardsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoUpdate(_ card: DAOCard,
                          for user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLCardsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
