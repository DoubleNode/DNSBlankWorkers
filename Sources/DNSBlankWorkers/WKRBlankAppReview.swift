//
//  WKRBlankAppReview.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankAppReview: WKRBaseAppReview {
    // MARK: - Internal Work Methods
    override open func intDoReview(with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAppReviewBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAppReviewResVoid {
        block?(.success)
        _ = resultBlock?(.completed)
        return .success
    }

    override open func intDoReview(using parameters: DNSDataDictionary,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAppReviewBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAppReviewResVoid {
        block?(.success)
        _ = resultBlock?(.completed)
        return .success
    }
}
