//
//  WKRBlankAuthenticationWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSProtocols
import Foundation

open class WKRBlankAuthenticationWorker: WKRBlankBaseWorker, PTCLAuthentication_Protocol
{
    public var callNextWhen: PTCLCallNextWhen = .whenUnhandled
    public var nextWorker: PTCLAuthentication_Protocol?

    public required init() {
        super.init()
    }
    public required init(call callNextWhen: PTCLCallNextWhen,
                         nextWorker: PTCLAuthentication_Protocol) {
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
    @discardableResult
    public func runDo(runNext: PTCLCallBlock?,
                      doWork: PTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Business Logic / Single Item CRUD

    open func doCheckAuthentication(using parameters: [String: Any],
                                    with progress: PTCLProgressBlock?,
                                    and block: PTCLAuthenticationBlockVoidBoolBoolAccessDataDNSError?) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doCheckAuthentication(using: parameters,
                                                        with: progress,
                                                        and: block)
        }
    }
    open func doSignIn(from username: String?,
                       and password: String?,
                       using parameters: [String: Any],
                       with progress: PTCLProgressBlock?,
                       and block: PTCLAuthenticationBlockVoidBoolAccessDataDNSError?) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doSignIn(from: username,
                                           and: password,
                                           using: parameters,
                                           with: progress,
                                           and: block)
        }
    }
    open func doSignOut(using parameters: [String: Any],
                        with progress: PTCLProgressBlock?,
                        and block: PTCLAuthenticationBlockVoidBoolDNSError?) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doSignOut(using: parameters,
                                            with: progress,
                                            and: block)
        }
    }
    open func doSignUp(from user: DAOUser?,
                       and password: String?,
                       using parameters: [String: Any],
                       with progress: PTCLProgressBlock?,
                       and block: PTCLAuthenticationBlockVoidBoolAccessDataDNSError?) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doSignUp(from: user,
                                           and: password,
                                           using: parameters,
                                           with: progress,
                                           and: block)
        }
    }
}
