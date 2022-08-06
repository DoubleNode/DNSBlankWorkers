//
//  WKRBlankCartWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSError
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
                      doWork: DNSPTCLCallResultBlock = { return $0?(.unhandled) }) -> Any? {
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Cart.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doAdd(_ basketItem: DAOBasketItem,
                      to basket: DAOBasket,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLCartBlkBasket?) {
        self.runDo(runNext: {
            return self.nextWorker?.doAdd(basketItem, to: basket, with: progress, and: block)
        },
        doWork: {
            return self.intDoAdd(basketItem, to: basket, with: progress, and: block, then: $0)
        })
    }
    public func doCheckout(for basket: DAOBasket,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLCartBlkOrder?) {
        self.runDo(runNext: {
            return self.nextWorker?.doCheckout(for: basket, with: progress, and: block)
        },
        doWork: {
            return self.intDoCheckout(for: basket, with: progress, and: block, then: $0)
        })
    }
    public func doCreate(with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkBasket?) {
        self.runDo(runNext: {
            return self.nextWorker?.doCreate(with: progress, and: block)
        },
        doWork: {
            return self.intDoCreate(with: progress, and: block, then: $0)
        })
    }
    public func doCreate(and add: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkBasket?) {
        self.runDo(runNext: {
            return self.nextWorker?.doCreate(and: add, with: progress, and: block)
        },
        doWork: {
            return self.intDoCreate(and: add, with: progress, and: block, then: $0)
        })
    }
    public func doLoadOrder(for id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCartBlkOrder?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadOrder(for: id, with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadOrder(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadOrders(for account: DAOAccount,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCartBlkAOrder?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadOrders(for: account, with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadOrders(for: account, with: progress, and: block, then: $0)
        })
    }
    public func doLoadOrders(for account: DAOAccount,
                             and state: DNSOrderState,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCartBlkAOrder?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadOrders(for: account, and: state, with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadOrders(for: account, and: state, with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ basket: DAOBasket,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRemove(basket, with: progress, and: block)
        },
        doWork: {
            return self.intDoRemove(basket, with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ basketItem: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRemove(basketItem, with: progress, and: block)
        },
        doWork: {
            return self.intDoRemove(basketItem, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ basket: DAOBasket,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(basket, with: progress, and: block)
        },
        doWork: {
            return self.intDoUpdate(basket, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ basketItem: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(basketItem, with: progress, and: block)
        },
        doWork: {
            return self.intDoUpdate(basketItem, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doAdd(_ basketItem: DAOBasketItem,
                      to basket: DAOBasket,
                      with block: WKRPTCLCartBlkBasket?) {
        self.doAdd(basketItem, to: basket, with: nil, and: block)
    }
    public func doCheckout(for basket: DAOBasket,
                           with block: WKRPTCLCartBlkOrder?) {
        self.doCheckout(for: basket, with: nil, and: block)
    }
    public func doCreate(with block: WKRPTCLCartBlkBasket?) {
        self.doCreate(with: nil, and: block)
    }
    public func doCreate(and add: DAOBasketItem,
                         with block: WKRPTCLCartBlkBasket?) {
        self.doCreate(and: add, with: nil, and: block)
    }
    public func doLoadOrder(for id: String,
                            with block: WKRPTCLCartBlkOrder?) {
        self.doLoadOrder(for: id, with: nil, and: block)
    }
    public func doLoadOrders(for account: DAOAccount,
                             with block: WKRPTCLCartBlkAOrder?) {
        self.doLoadOrders(for: account, with: nil, and: block)
    }
    public func doLoadOrders(for account: DAOAccount,
                             and state: DNSOrderState,
                             with block: WKRPTCLCartBlkAOrder?) {
        self.doLoadOrders(for: account, and: state, with: nil, and: block)
    }
    public func doRemove(_ basket: DAOBasket,
                         with block: WKRPTCLCartBlkVoid?) {
        self.doRemove(basket, with: nil, and: block)
    }
    public func doRemove(_ basketItem: DAOBasketItem,
                         with block: WKRPTCLCartBlkVoid?) {
        self.doRemove(basketItem, with: nil, and: block)
    }
    public func doUpdate(_ basket: DAOBasket,
                         with block: WKRPTCLCartBlkVoid?) {
        self.doUpdate(basket, with: nil, and: block)
    }
    public func doUpdate(_ basketItem: DAOBasketItem,
                         with block: WKRPTCLCartBlkVoid?) {
        self.doUpdate(basketItem, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoAdd(_ basketItem: DAOBasketItem,
                      to basket: DAOBasket,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLCartBlkBasket?,
                       then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoCheckout(for basket: DAOBasket,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLCartBlkOrder?,
                            then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoCreate(with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkBasket?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoCreate(and add: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkBasket?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadOrder(for id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCartBlkOrder?,
                             then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadOrders(for account: DAOAccount,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCartBlkAOrder?,
                              then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadOrders(for account: DAOAccount,
                             and state: DNSOrderState,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCartBlkAOrder?,
                              then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemove(_ basket: DAOBasket,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemove(_ basketItem: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ basket: DAOBasket,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ basketItem: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
