//
//  WKRBlankPassports.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankPassports: WKRBasePassports {
    // MARK: - Internal Work Methods
    override open func intDoBuildPassport(ofType passportType: String,
                                 using data: [String: String],
                                 for account: DAOAccount,
                                 with progress: DNSPTCLProgressBlock?,
                                 then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLPassportsPubData {
        _ = resultBlock?(.completed)
        return WKRPTCLPassportsFutData { $0(.success(Data())) }.eraseToAnyPublisher()
    }
}
