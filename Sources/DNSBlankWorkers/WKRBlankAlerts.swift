//
//  WKRBlankAlerts.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankAlerts: WKRBaseAlerts {
    // MARK: - Internal Work Methods
    override open func intDoLoadAlerts(for place: DAOPlace,
                              with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAlertsPubAAlert {
        _ = resultBlock?(.completed)
        return WKRPTCLAlertsFutAAlert { $0(.success([])) }.eraseToAnyPublisher()
    }
    override open func intDoLoadAlerts(for section: DAOSection,
                              with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAlertsPubAAlert {
        _ = resultBlock?(.completed)
        return WKRPTCLAlertsFutAAlert { $0(.success([])) }.eraseToAnyPublisher()
    }
    override open func intDoLoadAlerts(with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAlertsPubAAlert {
        _ = resultBlock?(.completed)
        return WKRPTCLAlertsFutAAlert { $0(.success([])) }.eraseToAnyPublisher()
    }
}
