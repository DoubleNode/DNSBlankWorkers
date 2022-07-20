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
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAccount?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLAccount,
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
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadAccount(for user: DAOUser,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLAccountBlkAccount?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadAccount(for: user, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadAccount(for: user, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(account: DAOAccount,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAccountBlkBool?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doUpdate(account: account, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(account: account, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadAccount(for user: DAOUser,
                              with block: WKRPTCLAccountBlkAccount?) throws {
        try self.doLoadAccount(for: user, with: nil, and: block)
    }
    public func doUpdate(account: DAOAccount,
                         with block: WKRPTCLAccountBlkBool?) throws {
        try self.doUpdate(account: account, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadAccount(for user: DAOUser,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLAccountBlkAccount?,
                               then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(account: DAOAccount,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAccountBlkBool?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
