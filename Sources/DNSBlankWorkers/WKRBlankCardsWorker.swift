//
//  WKRBlankDCardsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSProtocols
import Foundation

open class WKRBlankCardsWorker: WKRBlankBaseWorker, WKRPTCLCards {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLCards?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLCards,
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
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doAdd(_ card: DAOCard,
                      to user: DAOUser,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLCardsBlkBool?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doAdd(card, to: user, with: progress, and: block)
        },
        doWork: {
            return try self.intDoAdd(card, to: user, with: progress, and: block, then: $0)
        })
    }
    public func doLoadCard(for id: String,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLCardsBlkCard?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadCard(for: id, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadCard(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadCard(for transaction: DAOTransaction,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLCardsBlkCard?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadCard(for: transaction, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadCard(for: transaction, with: progress, and: block, then: $0)
        })
    }
    public func doLoadCards(for user: DAOUser,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCardsBlkACard?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadCards(for: user, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadCards(for: user, with: progress, and: block, then: $0)
        })
    }
    public func doLoadTransactions(for card: DAOCard,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLCardsBlkATransaction?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadTransactions(for: card, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadTransactions(for: card, with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ card: DAOCard,
                         from user: DAOUser,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCardsBlkBool?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doRemove(card, from: user, with: progress, and: block)
        },
        doWork: {
            return try self.intDoRemove(card, from: user, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ card: DAOCard,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCardsBlkBool?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doUpdate(card, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(card, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doAdd(_ card: DAOCard,
                      to user: DAOUser,
                      with block: WKRPTCLCardsBlkBool?) throws {
        try self.doAdd(card, to: user, with: nil, and: block)
    }
    public func doLoadCard(for id: String,
                           with block: WKRPTCLCardsBlkCard?) throws {
        try self.doLoadCard(for: id, with: nil, and: block)
    }
    public func doLoadCard(for transaction: DAOTransaction,
                           with block: WKRPTCLCardsBlkCard?) throws {
        try self.doLoadCard(for: transaction, with: nil, and: block)
    }
    public func doLoadCards(for user: DAOUser,
                            with block: WKRPTCLCardsBlkACard?) throws {
        try self.doLoadCards(for: user, with: nil, and: block)
    }
    public func doLoadTransactions(for card: DAOCard,
                                   with block: WKRPTCLCardsBlkATransaction?) throws {
        try self.doLoadTransactions(for: card, with: nil, and: block)
    }
    public func doRemove(_ card: DAOCard,
                         from user: DAOUser,
                         with block: WKRPTCLCardsBlkBool?) throws {
        try self.doRemove(card, from: user, with: nil, and: block)
    }
    public func doUpdate(_ card: DAOCard,
                         with block: WKRPTCLCardsBlkBool?) throws {
        try self.doUpdate(card, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoAdd(_ card: DAOCard,
                       to user: DAOUser,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLCardsBlkBool?,
                       then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadCard(for id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCardsBlkCard?,
                            then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadCard(for transaction: DAOTransaction,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCardsBlkCard?,
                            then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadCards(for user: DAOUser,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCardsBlkACard?,
                             then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadTransactions(for card: DAOCard,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLCardsBlkATransaction?,
                                    then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemove(_ card: DAOCard,
                          from user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLCardsBlkBool?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ card: DAOCard,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLCardsBlkBool?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
