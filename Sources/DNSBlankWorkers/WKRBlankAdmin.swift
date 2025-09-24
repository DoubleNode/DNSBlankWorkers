//
//  WKRBlankAdmin.swift
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

open class WKRBlankAdmin: WKRBaseAdmin {
    // MARK: - Internal Work Methods
    override open func intDoChange(_ user: DAOUser,
                          to role: DNSUserRole,
                          with progress: DNSPTCLProgressBlock?,
                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLAdminFutVoid { $0(.success) }.eraseToAnyPublisher()
    }
    override open func intDoCheckAdmin(with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubBool {
        _ = resultBlock?(.completed)
        return WKRPTCLAdminFutBool { $0(.success(false)) }.eraseToAnyPublisher()
    }
    override open func intDoCompleteDeleted(account: DAOAccount,
                                   with progress: DNSPTCLProgressBlock?,
                                   then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLAdminFutVoid { $0(.success) }.eraseToAnyPublisher()
    }
    override open func intDoDenyChangeRequest(for user: DAOUser,
                                     with progress: DNSPTCLProgressBlock?,
                                     then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLAdminFutVoid { $0(.success) }.eraseToAnyPublisher()
    }
    override open func intDoLoadChangeRequests(with progress: DNSPTCLProgressBlock?,
                                      // swiftlint:disable:next line_length
                                      then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubUserChangeRequest {
        _ = resultBlock?(.completed)
        return WKRPTCLAdminFutUserChangeRequest { $0(.success((nil, []))) }.eraseToAnyPublisher()
    }
    override open func intDoLoadDeletedAccounts(thatAre state: DNSPTCLDeletedStates,
                                       with progress: DNSPTCLProgressBlock?,
                                       and block: WKRPTCLAdminBlkADeletedAccount?,
                                       then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadDeletedStatus(with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLAdminBlkDeletedStatus?,
                                     then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadTabs(with progress: DNSPTCLProgressBlock?,
                            then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubAString {
        _ = resultBlock?(.completed)
        return WKRPTCLAdminFutAString { $0(.success([])) }.eraseToAnyPublisher()
    }
    override open func intDoRequestChange(to role: DNSUserRole,
                                 with progress: DNSPTCLProgressBlock?,
                                 then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLAdminFutVoid { $0(.success) }.eraseToAnyPublisher()
    }
}
