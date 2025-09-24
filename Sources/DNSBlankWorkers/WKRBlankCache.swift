//
//  WKRBlankCache.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSError
import DNSProtocols
#if canImport(UIKit)
import UIKit
#endif

open class WKRBlankCache: WKRBaseCache {
     // MARK: - Internal Work Methods
    override open func intDoDeleteObject(for id: String,
                                with progress: DNSPTCLProgressBlock?,
                                then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLCacheFutVoid { $0(.success) }.eraseToAnyPublisher()
    }
    override open func intDoLoadImage(from url: NSURL,
                             for id: String,
                             with progress: DNSPTCLProgressBlock?,
                             then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubImage {
        _ = resultBlock?(.completed)
        return WKRPTCLCacheFutImage { $0(.success(UIImage())) }.eraseToAnyPublisher()
    }
    override open func intDoReadObject(for id: String,
                              with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubAny {
        _ = resultBlock?(.completed)
        return WKRPTCLCacheFutAny { $0(.success(Data())) }.eraseToAnyPublisher()
    }
    override open func intDoReadString(for id: String,
                              with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubString {
        _ = resultBlock?(.completed)
        return WKRPTCLCacheFutString { $0(.success("")) }.eraseToAnyPublisher()
    }
    override open func intDoUpdate(object: Any,
                          for id: String,
                          with progress: DNSPTCLProgressBlock?,
                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubAny {
        _ = resultBlock?(.completed)
        return WKRPTCLCacheFutAny { $0(.success(object)) }.eraseToAnyPublisher()
    }
}
