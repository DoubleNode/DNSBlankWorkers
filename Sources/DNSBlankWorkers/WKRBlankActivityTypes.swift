//
//  WKRBlankActivityTypes.swift
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

open class WKRBlankActivityTypes: WKRBaseActivityTypes {
    // MARK: - Internal Work Methods
    override open func intDoLoadActivityType(for code: String,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLActivityTypesBlkActivityType?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOActivityType()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadActivityType(for tag: DNSString,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLActivityTypesBlkActivityType?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOActivityType()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadActivityTypes(with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLActivityTypesBlkAActivityType?,
                                     then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadPricing(for activityType: DAOActivityType,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLActivityTypesBlkPricing?,
                               then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOPricing()))
        _ = resultBlock?(.completed)
    }
    override open func intDoReact(with reaction: DNSReactionType,
                        to activityType: DAOActivityType,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLActivityTypesBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUnreact(with reaction: DNSReactionType,
                          to activityType: DAOActivityType,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLActivityTypesBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ activityType: DAOActivityType,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLActivityTypesBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ pricing: DAOPricing,
                          for activityType: DAOActivityType,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLActivityTypesBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
