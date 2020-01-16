//
//  WKRBlankPasswordStrengthWorker.swift
//  DoubleNode Core - DNSBlankWorkers
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankPasswordStrengthWorker: WKRBlankBaseWorker, PTCLPasswordStrength_Protocol
{
    public var nextWorker: PTCLPasswordStrength_Protocol?

    public required init() {
        super.init()
    }

    public required init(nextWorker: PTCLPasswordStrength_Protocol) {
        super.init()
        self.nextWorker = nextWorker
    }

    override open func enableOption(option: String) {
        nextWorker?.enableOption(option: option)
    }

    override open func disableOption(option: String) {
        nextWorker?.disableOption(option: option)
    }

    // MARK: - Business Logic / Single Item CRUD

    open func doCheckPasswordStrength(for password: String) throws -> PTCLPasswordStrengthType {
        guard nextWorker != nil else {
            return .weak
        }

        return try nextWorker!.doCheckPasswordStrength(for: password)
    }
}
