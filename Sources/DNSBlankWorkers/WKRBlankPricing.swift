//
//  WKRBlankPricing.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankPricing: WKRBasePricing {
    // MARK: - Internal Work Methods
    override open func intDoLoadPricingItems(for pricingTier: DAOPricingTier,
                                    and pricingSeason: DAOPricingSeason,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLPricingBlkAPricingItem?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadPricingSeasons(for pricingTier: DAOPricingTier,
                                      with progress: DNSPTCLProgressBlock?,
                                      and block: WKRPTCLPricingBlkAPricingSeason?,
                                      then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadPricingTiers(with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLPricingBlkAPricingTier?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoRemove(_ pricingTier: DAOPricingTier,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPricingBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoRemove(_ pricingSeason: DAOPricingSeason,
                          for pricingTier: DAOPricingTier,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPricingBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoRemove(_ pricingItem: DAOPricingItem,
                          for pricingTier: DAOPricingTier,
                          and pricingSeason: DAOPricingSeason,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPricingBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ pricingTier: DAOPricingTier,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPricingBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ pricingSeason: DAOPricingSeason,
                          for pricingTier: DAOPricingTier,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPricingBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ pricingItem: DAOPricingItem,
                          for pricingTier: DAOPricingTier,
                          and pricingSeason: DAOPricingSeason,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPricingBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
