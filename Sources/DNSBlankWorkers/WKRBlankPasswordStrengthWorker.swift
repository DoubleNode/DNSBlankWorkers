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
    public func register(nextWorker: PTCLPasswordStrength_Protocol,
                         for callNextWhen: PTCLCallNextWhen) {
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

    // MARK: - Business Logic / Single Item CRUD

    open func doCheckPasswordStrength(for password: String) throws -> PTCLPasswordStrengthType {
        return try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doCheckPasswordStrength(for: password)
        } as! PTCLPasswordStrengthType
    }
}
