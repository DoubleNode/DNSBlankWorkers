//
//  WKRBlankPassStrength.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import DNSProtocols
import Foundation

open class WKRBlankPassStrength: WKRBasePassStrength {
    // MARK: - Internal Work Methods
    override open func intDoCheckPassStrength(for password: String,
                                     then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLPassStrengthResVoid {
        _ = resultBlock?(.completed)
        return .success(WKRPTCLPassStrength.Level.weak)
    }
}
