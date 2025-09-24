//
//  WKRBlankBeacons.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankBeacons: WKRBaseBeacons {
    // MARK: - Internal Work Methods
    override open func intDoLoadBeacons(in place: DAOPlace,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLBeaconsBlkABeacon?,
                               then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadBeacons(in place: DAOPlace,
                               for activity: DAOActivity,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLBeaconsBlkABeacon?,
                               then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoRangeBeacons(named uuids: [UUID],
                                for processKey: String,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLBeaconsBlkABeacon?,
                                then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoStopRangeBeacons(for processKey: String,
                                    then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLBeaconsResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
}
