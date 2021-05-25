//
//  WKRBlankPasswordStrengthWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankPasswordStrengthWorker: WKRBlankBaseWorker, PTCLPasswordStrength_Protocol
{
    public var callNextWhen: PTCLCallNextWhen = .whenUnhandled
    public var nextWorker: PTCLPasswordStrength_Protocol?

    public var minimumLength: Int32 = 6

    public required init() {
        super.init()
    }

    public required init(call callNextWhen: PTCLCallNextWhen,
                         nextWorker: PTCLPasswordStrength_Protocol) {
        super.init()
        self.callNextWhen = callNextWhen
        self.nextWorker = nextWorker
    }

    override open func disableOption(_ option: String) {
        super.disableOption(option)
        nextWorker?.disableOption(option)
    }
    override open func enableOption(_ option: String) {
        super.enableOption(option)
        nextWorker?.enableOption(option)
    }

    // MARK: - Business Logic / Single Item CRUD

    open func doCheckPasswordStrength(for password: String) throws -> PTCLPasswordStrengthType {
        guard
            [.always, .whenUnhandled].contains(where: { $0 == self.callNextWhen }),
            let nextWorker = self.nextWorker
        else { return .weak }
        return try nextWorker.doCheckPasswordStrength(for: password)
    }
}
