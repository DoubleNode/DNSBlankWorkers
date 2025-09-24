//
//  WKRBlankAppEvents.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import DNSProtocols
import Foundation

open class WKRBlankAppEvents: WKRBaseAppEvents {
    // MARK: - Internal Work Methods
    override open func intDoLoadAppEvents(with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLAppEventsBlkAAppEvent?,
                                 then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
}
