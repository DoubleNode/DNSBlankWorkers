//
//  WKRBlankAccount.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankAccount: WKRBaseAccount {
    // MARK: - Internal Work Methods
    override open func intDoActivate(account: DAOAccount,
                                     with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLAccountBlkBool?,
                                     then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(true))
        _ = resultBlock?(.completed)
    }
    override open func intDoApprove(linkRequest: DAOAccountLinkRequest,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLAccountBlkVoid?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoDeactivate(account: DAOAccount,
                                       with progress: DNSPTCLProgressBlock?,
                                       and block: WKRPTCLAccountBlkVoid?,
                                       then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoDecline(linkRequest: DAOAccountLinkRequest,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLAccountBlkVoid?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoDelete(account: DAOAccount,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLAccountBlkVoid?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoLink(account: DAOAccount,
                                 to user: DAOUser,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLAccountBlkVoid?,
                                 then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoLink(account: DAOAccount,
                                 to place: DAOPlace,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLAccountBlkVoid?,
                                 then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadAccount(for id: String,
                                        with progress: DNSProtocols.DNSPTCLProgressBlock?,
                                        and block: WKRPTCLAccountBlkAccount?,
                                        then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOAccount()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadAccounts(for place: DAOPlace,
                                         with progress: DNSPTCLProgressBlock?,
                                         and block: WKRPTCLAccountBlkAAccount?,
                                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadAccounts(for user: DAOUser,
                                         with progress: DNSProtocols.DNSPTCLProgressBlock?,
                                         and block: WKRPTCLAccountBlkAAccount?,
                                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadCurrentAccounts(with progress: DNSPTCLProgressBlock?,
                                                and block: WKRPTCLAccountBlkAAccount?,
                                                then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadPlaces(for account: DAOAccount,
                                       with progress: DNSProtocols.DNSPTCLProgressBlock?,
                                       and block: WKRPTCLAccountBlkAPlace?,
                                       then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoRename(accountId: String,
                                   to newAccountId: String,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLAccountBlkVoid?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoSearchAccounts(using parameters: DNSDataDictionary,
                                           with progress: DNSPTCLProgressBlock?,
                                           and block: WKRPTCLAccountBlkAAccount?,
                                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoUnlink(account: DAOAccount,
                                   from user: DAOUser,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLAccountBlkVoid?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUnlink(account: DAOAccount,
                                   from place: DAOPlace,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLAccountBlkVoid?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(account: DAOAccount,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLAccountBlkVoid?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoVerify(account: DAOAccount,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLAccountBlkVoid?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
