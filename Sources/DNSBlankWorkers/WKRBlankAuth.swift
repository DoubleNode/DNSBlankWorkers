//
//  WKRBlankAuth.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataContracts
import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankAuth: WKRBaseAuth {
    // MARK: - Internal Work Methods
    override open func intDoCheckAuth(using parameters: DNSDataDictionary,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLAuthBlkBoolBoolAccessData?,
                             then resultBlock: DNSPTCLResultBlock?) {
        block?(.success((false, false, WKRBaseAuthAccessData())))
        _ = resultBlock?(.completed)
    }
    override open func intDoLinkAuth(from username: String,
                            and password: String,
                            using parameters: DNSDataDictionary,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLAuthBlkBoolAccessData?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success((false, WKRBaseAuthAccessData())))
        _ = resultBlock?(.completed)
    }
    override open func intDoPasswordResetStart(from username: String?,
                                      using parameters: DNSDataDictionary,
                                      with progress: DNSPTCLProgressBlock?,
                                      and block: WKRPTCLAuthBlkVoid?,
                                      then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoSignIn(from username: String?,
                          and password: String?,
                          using parameters: DNSDataDictionary,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAuthBlkBoolAccessData?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success((false, WKRBaseAuthAccessData())))
        _ = resultBlock?(.completed)
    }
    override open func intDoSignOut(using parameters: DNSDataDictionary,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLAuthBlkVoid?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoSignUp(from user: (any DAOUserProtocol)?,
                          and password: String?,
                          using parameters: DNSDataDictionary,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAuthBlkBoolAccessData?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success((false, WKRBaseAuthAccessData())))
        _ = resultBlock?(.completed)
    }
}
