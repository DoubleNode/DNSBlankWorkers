//
//  WKRBlankAccountWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSProtocols
import Foundation

open class WKRBlankAccountWorker: WKRBlankBaseWorker, WKRPTCLAccount {
    public var callNextWhen: WKRPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAccount?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLAccount,
                         for callNextWhen: WKRPTCLWorker.Call.NextWhen) {
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
    public func runDo(runNext: WKRPTCLCallBlock?,
                      doWork: WKRPTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Protocol Interface Methods
    public func doLoadAccount(for user: DAOUser,
                              with progress: WKRPTCLProgressBlock?,
                              and block: WKRPTCLAccountBlockAccount?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadAccount(for: user, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadAccount(for: user, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(account: DAOAccount,
                         with progress: WKRPTCLProgressBlock?,
                         and block: WKRPTCLAccountBlockBool?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doUpdate(account: account, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(account: account, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Internal Work Methods
    open func intDoLoadAccount(for user: DAOUser,
                               with progress: WKRPTCLProgressBlock?,
                               and block: WKRPTCLAccountBlockAccount?,
                               then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(account: DAOAccount,
                          with progress: WKRPTCLProgressBlock?,
                          and block: WKRPTCLAccountBlockBool?,
                          then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
