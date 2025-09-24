//
//  WKRBlankProducts.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import DNSDataTypes
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankProducts: WKRBaseProducts {
    // MARK: - Internal Work Methods
    override open func intDoLoadPricing(for product: DAOProduct,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLProductsBlkPricing?,
                               then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOPricing()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadProduct(for id: String,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLProductsBlkProduct?,
                               then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOProduct()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadProduct(for id: String,
                               and place: DAOPlace,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLProductsBlkProduct?,
                               then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOProduct()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadProducts(with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLProductsBlkAProduct?,
                                then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadProducts(for place: DAOPlace,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLProductsBlkAProduct?,
                                then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoReact(with reaction: DNSReactionType,
                         to product: DAOProduct,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLProductsBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoRemove(_ product: DAOProduct,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLProductsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUnreact(with reaction: DNSReactionType,
                           to product: DAOProduct,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLProductsBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ pricing: DAOPricing,
                          for product: DAOProduct,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLProductsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ product: DAOProduct,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLProductsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
