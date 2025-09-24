//
//  WKRBlankEvents.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import DNSDataTypes
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankEvents: WKRBaseEvents {
    // MARK: - Internal Work Methods
    override open func intDoLoadCurrentEvents(with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLEventsBlkAPlace?,
                                     then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadEvents(for place: DAOPlace,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLEventsBlkAEvent?,
                              then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadPricing(for event: DAOEvent,
                               and place: DAOPlace,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLEventsBlkPricing?,
                               then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOPricing()))
        _ = resultBlock?(.completed)
    }
    override open func intDoReact(with reaction: DNSReactionType,
                         to event: DAOEvent,
                         for place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLEventsBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoRemove(_ event: DAOEvent,
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLEventsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoRemove(_ eventDay: DAOEventDay,
                          for event: DAOEvent,
                          and place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLEventsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUnreact(with reaction: DNSReactionType,
                           to event: DAOEvent,
                           for place: DAOPlace,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLEventsBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ event: DAOEvent,
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLEventsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ eventDay: DAOEventDay,
                          for event: DAOEvent,
                          and place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLEventsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ pricing: DAOPricing,
                          for event: DAOEvent,
                          and place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLEventsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoView(_ event: DAOEvent,
                        for place: DAOPlace,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLEventsBlkMeta?,
                        then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
}
