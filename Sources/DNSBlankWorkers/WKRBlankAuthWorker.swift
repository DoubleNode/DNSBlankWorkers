//
//  WKRBlankAuthWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSProtocols
import Foundation

open class WKRBlankAuthWorker: WKRBlankBaseWorker, WKRPTCLAuth {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAuth?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLAuth,
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
    public func doCheckAuthentication(using parameters: [String: Any],
                                      with progress: DNSPTCLProgressBlock?,
                                      and block: WKRPTCLAuthBlkBoolBoolAccessData?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doCheckAuthentication(using: parameters,
                                                              with: progress, and: block)
        },
        doWork: {
            return try self.intDoCheckAuthentication(using: parameters,
                                                     with: progress, and: block, then: $0)
        })
    }
    public func doSignIn(from username: String?,
                         and password: String?,
                         using parameters: [String: Any],
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAuthBlkBoolAccessData?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doSignIn(from: username, and: password, using: parameters,
                                                 with: progress, and: block)
        },
        doWork: {
            return try self.intDoSignIn(from: username, and: password, using: parameters,
                                        with: progress, and: block, then: $0)
        })
    }
    public func doSignOut(using parameters: [String: Any],
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAuthBlkVoid?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doSignOut(using: parameters, with: progress, and: block)
        },
        doWork: {
            return try self.intDoSignOut(using: parameters, with: progress, and: block, then: $0)
        })
    }
    public func doSignUp(from user: DAOUser?,
                         and password: String?,
                         using parameters: [String: Any],
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAuthBlkBoolAccessData?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doSignUp(from: user, and: password, using: parameters,
                                                 with: progress, and: block)
        },
        doWork: {
            return try self.intDoSignUp(from: user, and: password, using: parameters,
                                        with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doCheckAuthentication(using parameters: [String: Any],
                                      with block: WKRPTCLAuthBlkBoolBoolAccessData?) throws {
        try self.doCheckAuthentication(using: parameters, with: nil, and: block)
    }
    public func doSignIn(from username: String?,
                         and password: String?,
                         using parameters: [String: Any],
                         with block: WKRPTCLAuthBlkBoolAccessData?) throws {
        try self.doSignIn(from: username, and: password, using: parameters, with: nil, and: block)
    }
    public func doSignOut(using parameters: [String: Any],
                          with block: WKRPTCLAuthBlkVoid?) throws {
        try self.doSignOut(using: parameters, with: nil, and: block)
    }
    public func doSignUp(from user: DAOUser?,
                         and password: String?,
                         using parameters: [String: Any],
                         with block: WKRPTCLAuthBlkBoolAccessData?) throws {
        try self.doSignUp(from: user, and: password, using: parameters, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoCheckAuthentication(using parameters: [String: Any],
                                       with progress: DNSPTCLProgressBlock?,
                                       and block: WKRPTCLAuthBlkBoolBoolAccessData?,
                                       then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoSignIn(from username: String?,
                          and password: String?,
                          using parameters: [String: Any],
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAuthBlkBoolAccessData?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoSignOut(using parameters: [String: Any],
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLAuthBlkVoid?,
                           then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoSignUp(from user: DAOUser?,
                          and password: String?,
                          using parameters: [String: Any],
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAuthBlkBoolAccessData?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}