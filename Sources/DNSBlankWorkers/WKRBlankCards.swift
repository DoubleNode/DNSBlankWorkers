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

open class WKRBlankCards: WKRBaseCards {
    // MARK: - Internal Work Methods
    override open func intDoAdd(_ card: DAOCard,
                       to user: DAOUser,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLCardsBlkVoid?,
                       then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadCard(for id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCardsBlkCard?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOCard()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadCard(for transaction: DAOTransaction,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLCardsBlkCard?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOCard()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadCards(for user: DAOUser,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLCardsBlkACard?,
                             then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadTransactions(for card: DAOCard,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLCardsBlkATransaction?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoRemove(_ card: DAOCard,
                          from user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLCardsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ card: DAOCard,
                          for user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLCardsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
