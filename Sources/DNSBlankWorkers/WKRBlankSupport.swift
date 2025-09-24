//
//  WKRBlankSupport.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSError
import DNSProtocols
#if canImport(UIKit)
import UIKit
#endif

open class WKRBlankSupport: WKRBaseSupport {
    // MARK: - Internal Work Methods
    override open func intDoGetUpdatedCount(with progress: DNSPTCLProgressBlock?,
                                   then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLSupportPubInt {
        _ = resultBlock?(.completed)
        return WKRPTCLSupportFutInt { $0(.success(0)) }.eraseToAnyPublisher()
    }
    override open func intDoPrepare(attachment image: UIImage,
                           with progress: DNSPTCLProgressBlock?,
                           then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLSupportPubAttach {
        _ = resultBlock?(.completed)
        return WKRPTCLSupportFutAttach { $0(.success(WKRPTCLSupportAttachment(image: image))) }.eraseToAnyPublisher()
    }
    override open func intDoSendRequest(subject: String,
                               body: String,
                               tags: [String],
                               attachments: [WKRPTCLSupportAttachment],
                               properties: [String: String],
                               with progress: DNSPTCLProgressBlock?,
                               then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLSupportPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLSupportFutVoid { $0(.success) }.eraseToAnyPublisher()
    }
}
