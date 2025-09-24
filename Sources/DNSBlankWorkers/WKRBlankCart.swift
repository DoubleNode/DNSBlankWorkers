//
//  WKRBlankCart.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSDataTypes
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankCart: WKRBaseCart {
    // MARK: - Internal Work Methods
    override open func intDoAdd(_ basketItem: DAOBasketItem,
                      to basket: DAOBasket,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLCartBlkBasket?,
                       then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOBasket()))
        _ = resultBlock?(.completed)
    }
    override open func intDoCheckout(for basket: DAOBasket,
                            using card: DAOCard,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCartBlkOrder?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOOrder()))
        _ = resultBlock?(.completed)
    }
    override open func intDoCreate(with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkBasket?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOBasket()))
        _ = resultBlock?(.completed)
    }
    override open func intDoCreate(and add: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkBasket?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOBasket()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadOrder(for id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCartBlkOrder?,
                             then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOOrder()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadOrders(for account: DAOAccount,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCartBlkAOrder?,
                              then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadOrders(for account: DAOAccount,
                             and state: DNSOrderState,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCartBlkAOrder?,
                              then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoRemove(_ basket: DAOBasket,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoRemove(_ basketItem: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ basket: DAOBasket,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ basketItem: DAOBasketItem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLCartBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
