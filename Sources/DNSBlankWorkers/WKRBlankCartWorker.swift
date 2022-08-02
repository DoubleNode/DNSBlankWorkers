//
//  WKRBlankCartWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSProtocols
import Foundation

open class WKRBlankCartWorker: WKRBlankBaseWorker, WKRPTCLCart {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLCart?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLCart,
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
    public func doAdd(_ basketItem: DAOBasketItem,
                      to basket: DAOBasket,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLCartBlkBasket?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doAdd(basketItem, to: basket, with: progress, and: block)
        },
        doWork: {
            return try self.intDoAdd(basketItem, to: basket, with: progress, and: block, then: $0)
        })
    }
    public func doCheckout(for basket: DAOBasket,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLCartBlkOrder?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doCheckout(for: basket, with: progress, and: block)
        },
        doWork: {
            return try self.intDoCheckout(for: basket, with: progress, and: block, then: $0)
        })
    }
    public func doCreate(with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkBasket?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doCreate(with: progress, and: block)
        },
        doWork: {
            return try self.intDoCreate(with: progress, and: block, then: $0)
        })
    }
    public func doCreate(and add: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkBasket?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doCreate(and: add, with: progress, and: block)
        },
        doWork: {
            return try self.intDoCreate(and: add, with: progress, and: block, then: $0)
        })
    }
    public func doLoadOrder(for id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCartBlkOrder?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadOrder(for: id, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadOrder(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadOrders(for account: DAOAccount,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCartBlkAOrder?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadOrders(for: account, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadOrders(for: account, with: progress, and: block, then: $0)
        })
    }
    public func doLoadOrders(for account: DAOAccount,
                             and state: DNSOrderState,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCartBlkAOrder?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadOrders(for: account, and: state, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadOrders(for: account, and: state, with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ basket: DAOBasket,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doRemove(basket, with: progress, and: block)
        },
        doWork: {
            return try self.intDoRemove(basket, with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ basketItem: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doRemove(basketItem, with: progress, and: block)
        },
        doWork: {
            return try self.intDoRemove(basketItem, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ basket: DAOBasket,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doUpdate(basket, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(basket, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ basketItem: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doUpdate(basketItem, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(basketItem, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doAdd(_ basketItem: DAOBasketItem,
                      to basket: DAOBasket,
                      with block: WKRPTCLCartBlkBasket?) throws {
        try self.doAdd(basketItem, to: basket, with: nil, and: block)
    }
    public func doCheckout(for basket: DAOBasket,
                           with block: WKRPTCLCartBlkOrder?) throws {
        try self.doCheckout(for: basket, with: nil, and: block)
    }
    public func doCreate(with block: WKRPTCLCartBlkBasket?) throws {
        try self.doCreate(with: nil, and: block)
    }
    public func doCreate(and add: DAOBasketItem,
                         with block: WKRPTCLCartBlkBasket?) throws {
        try self.doCreate(and: add, with: nil, and: block)
    }
    public func doLoadOrder(for id: String,
                            with block: WKRPTCLCartBlkOrder?) throws {
        try self.doLoadOrder(for: id, with: nil, and: block)
    }
    public func doLoadOrders(for account: DAOAccount,
                             with block: WKRPTCLCartBlkAOrder?) throws {
        try self.doLoadOrders(for: account, with: nil, and: block)
    }
    public func doLoadOrders(for account: DAOAccount,
                             and state: DNSOrderState,
                             with block: WKRPTCLCartBlkAOrder?) throws {
        try self.doLoadOrders(for: account, and: state, with: nil, and: block)
    }
    public func doRemove(_ basket: DAOBasket,
                         with block: WKRPTCLCartBlkVoid?) throws {
        try self.doRemove(basket, with: nil, and: block)
    }
    public func doRemove(_ basketItem: DAOBasketItem,
                         with block: WKRPTCLCartBlkVoid?) throws {
        try self.doRemove(basketItem, with: nil, and: block)
    }
    public func doUpdate(_ basket: DAOBasket,
                         with block: WKRPTCLCartBlkVoid?) throws {
        try self.doUpdate(basket, with: nil, and: block)
    }
    public func doUpdate(_ basketItem: DAOBasketItem,
                         with block: WKRPTCLCartBlkVoid?) throws {
        try self.doUpdate(basketItem, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoAdd(_ basketItem: DAOBasketItem,
                      to basket: DAOBasket,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLCartBlkBasket?,
                       then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoCheckout(for basket: DAOBasket,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLCartBlkOrder?,
                            then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoCreate(with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkBasket?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoCreate(and add: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkBasket?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadOrder(for id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCartBlkOrder?,
                             then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadOrders(for account: DAOAccount,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCartBlkAOrder?,
                              then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadOrders(for account: DAOAccount,
                             and state: DNSOrderState,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCartBlkAOrder?,
                              then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemove(_ basket: DAOBasket,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemove(_ basketItem: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ basket: DAOBasket,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ basketItem: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
