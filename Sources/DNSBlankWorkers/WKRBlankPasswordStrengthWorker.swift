//
//  WKRBlankPasswordStrengthWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankPasswordStrengthWorker: WKRBlankBaseWorker, WKRPTCLPasswordStrength {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLPasswordStrength?

    public var minimumLength: Int32 = 6

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLPasswordStrength,
                         for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
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
    @discardableResult
    public func runDo(runNext: DNSPTCLCallBlock?,
                      doWork: DNSPTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doCheckPasswordStrength(for password: String) throws -> WKRPTCLPasswordStrength.Level {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doCheckPasswordStrength(for: password)
        },
        doWork: {
            return try self.intDoCheckPasswordStrength(for: password, then: $0)
        }) as! WKRPTCLPasswordStrength.Level
    }

    // MARK: - Internal Work Methods
    open func intDoCheckPasswordStrength(for password: String,
                                         then resultBlock: DNSPTCLResultBlock?) throws -> WKRPTCLPasswordStrength.Level {
        return resultBlock?(.unhandled) as! WKRPTCLPasswordStrength.Level
    }
}
