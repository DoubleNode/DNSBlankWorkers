//
//  WKRBlankGeo.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import DNSCore
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankGeo: WKRBaseGeo {
    // MARK: - Internal Work Methods
    override open func intDoLocate(with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLGeoBlkStringLocation?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(("", CLLocation(from: DNSDataDictionary()))))
        _ = resultBlock?(.completed)
    }
    override open func intDoLocate(_ address: DNSPostalAddress,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLGeoBlkStringLocation?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(("", CLLocation(from: DNSDataDictionary()))))
        _ = resultBlock?(.completed)
    }
    override open func intDoTrackLocation(for processKey: String,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLGeoBlkStringLocation?,
                                 then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(("", CLLocation(from: DNSDataDictionary()))))
        _ = resultBlock?(.completed)
    }
    override open func intDoStopTrackLocation(for processKey: String,
                                     then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLGeoResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
}
