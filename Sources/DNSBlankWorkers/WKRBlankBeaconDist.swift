//
//  WKRBlankBeaconDist.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSError
import DNSProtocols

open class WKRBlankBeaconDist: WKRBaseBeaconDist {
    // MARK: - Internal Work Methods
    override open func intDoLoadBeaconDistances(with progress: DNSPTCLProgressBlock?,
                                       and block: WKRPTCLBeaconDistBlkABeaconDistance?,
                                       then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
}
