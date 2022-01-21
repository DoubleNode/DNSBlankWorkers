//
//  WKRBlankPasswordStrengthWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankPasswordStrengthWorker: WKRBlankBaseWorker, PTCLPasswordStrength
{
    public var callNextWhen: PTCLProtocol.Call.NextWhen = .whenUnhandled
    public var nextWorker: PTCLPasswordStrength?
    public var systemsStateWorker: PTCLSystemsState? = WKRBlankSystemsStateWorker()

    public var minimumLength: Int32 = 6

    public required init() {
        super.init()
    }
    public func register(nextWorker: PTCLPasswordStrength,
                         for callNextWhen: PTCLProtocol.Call.NextWhen) {
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
    public func runDo(runNext: PTCLCallBlock?,
                      doWork: PTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Protocol Interface Methods
    public func doCheckPasswordStrength(for password: String) throws -> PTCLPasswordStrength.Level {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doCheckPasswordStrength(for: password)
        },
        doWork: {
            return try self.intDoCheckPasswordStrength(for: password, then: $0)
        }) as! PTCLPasswordStrength.Level
    }

    // MARK: - Internal Work Methods
    open func intDoCheckPasswordStrength(for password: String,
                                         then resultBlock: PTCLResultBlock?) throws -> PTCLPasswordStrength.Level {
        return resultBlock?(.unhandled) as! PTCLPasswordStrength.Level
    }
}
