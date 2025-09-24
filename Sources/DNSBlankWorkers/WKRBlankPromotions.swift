//
//  WKRBlankPromotions.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import DNSDataUIObjects
import DNSDataTypes
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankPromotions: WKRBasePromotions {
    // MARK: - Internal Work Methods
    override open func intDoActivate(_ id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLPromotionsBlkVoid?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoDelete(_ promotion: DAOPromotion,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPromotionsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoDispense(_ id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLPromotionsBlkVoid?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadPromotion(for id: String,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLPromotionsBlkPromotion?,
                                 then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOPromotion()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadPromotions(for account: DAOAccount?,
                                  with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLPromotionsBlkAPromotion?,
                                  then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadPromotions(for path: String,
                                  with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLPromotionsBlkAPromotion?,
                                  then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoReact(with reaction: DNSReactionType,
                         to promotion: DAOPromotion,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPromotionsBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUnreact(with reaction: DNSReactionType,
                           to promotion: DAOPromotion,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLPromotionsBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ promotion: DAOPromotion,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPromotionsBlkPromotion?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOPromotion()))
        _ = resultBlock?(.completed)
    }
}
