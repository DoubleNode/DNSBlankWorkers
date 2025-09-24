//
//  WKRBlankIdentity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSError
import DNSProtocols

open class WKRBlankIdentity: WKRBaseIdentity {
    // MARK: - Internal Work Methods
    override open func intDoClearIdentity(with progress: DNSPTCLProgressBlock?,
                                 then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLIdentityPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
    }
    override open func intDoJoin(group: String,
                        with progress: DNSPTCLProgressBlock?,
                        then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLIdentityPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
    }
    override open func intDoLeave(group: String,
                         with progress: DNSPTCLProgressBlock?,
                         then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLIdentityPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
    }
    override open func intDoSetIdentity(using data: DNSDataDictionary,
                               with progress: DNSPTCLProgressBlock?,
                               then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLIdentityPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
   }
}
