//
//  WKRBlankCms.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSError
import DNSProtocols

open class WKRBlankCms: WKRBaseCms {
     // MARK: - Internal Work Methods
    override open func intDoLoad(for group: String,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLCmsBlkAAny?,
                        then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
}
