//
//  WKRBlankUsers.swift
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

open class WKRBlankUsers: WKRBaseUsers {
    // MARK: - Internal Work Methods
    override open func intDoActivate(_ user: DAOUser,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLUsersBlkBool?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(false))
        _ = resultBlock?(.completed)
    }
    override open func intDoConfirm(pendingUser: DAOUser,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLUsersBlkVoid?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoConsent(childUser: DAOUser,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLUsersBlkVoid?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadCurrentUser(with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLUsersBlkUser?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOUser()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadChildUsers(for user: DAOUser,
                                  with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLUsersBlkAUser?,
                                  then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadLinkRequests(for user: DAOUser,
                                    using parameters: DNSDataDictionary,
                                    with progress: DNSProtocols.DNSPTCLProgressBlock?,
                                    and block: WKRPTCLUsersBlkAAccountLinkRequest?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadPendingUsers(for user: DAOUser,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLUsersBlkAUser?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadUnverifiedAccounts(for user: DAOUser,
                                          with progress: DNSPTCLProgressBlock?,
                                          and block: WKRPTCLUsersBlkAAccount?,
                                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadUser(for id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLUsersBlkUser?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOUser()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadUsers(for account: DAOAccount,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLUsersBlkAUser?,
                             then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoReact(with reaction: DNSReactionType,
                         to user: DAOUser,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLUsersBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoRemove(_ user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLUsersBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUnreact(with reaction: DNSReactionType,
                           to user: DAOUser,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLUsersBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ user: DAOUser,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLUsersBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
