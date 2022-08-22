//
//  WKRBlankAdmin.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankAdmin: WKRBlankBase, WKRPTCLAdmin {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAdmin?

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLAdmin,
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
                      doWork: DNSPTCLCallResultBlock = { return $0?(.unhandled) }) -> Any? {
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    @discardableResult
    public func runDoPub(runNext: DNSPTCLCallBlock?,
                         doWork: DNSPTCLCallResultBlock = { return $0?(.unhandled) }) -> Any? {
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Admin.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doChange(_ user: DAOUser,
                         to role: DNSUserRole,
                         with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubVoid {
        // swiftlint:disable:next force_try
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLAdminFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return nextWorker.doChange(user, to: role, with: progress)
        },
                                  doWork: {
            return self.intDoChange(user, to: role, with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAdminPubVoid
    }
    public func doCheckAdmin(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubBool {
        // swiftlint:disable:next force_try
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLAdminFutBool { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doCheckAdmin(with: progress)
        },
                                  doWork: {
            return self.intDoCheckAdmin(with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAdminPubBool
    }
    public func doDenyChangeRequest(for user: DAOUser,
                                    with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubVoid {
        // swiftlint:disable:next force_try
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLAdminFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return nextWorker.doDenyChangeRequest(for: user, with: progress)
        },
                                  doWork: {
            return self.intDoDenyChangeRequest(for: user, with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAdminPubVoid
    }
    public func doLoadChangeRequests(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubUserChangeRequest {
        // swiftlint:disable:next force_try
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                // swiftlint:disable:next line_length
                return WKRPTCLAdminFutUserChangeRequest { $0(.success((nil, []))) }.eraseToAnyPublisher()
            }
            return nextWorker.doLoadChangeRequests(with: progress)
        },
                                  doWork: {
            return self.intDoLoadChangeRequests(with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAdminPubUserChangeRequest
    }
    public func doLoadTabs(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubAString {
        // swiftlint:disable:next force_try
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLAdminFutAString { $0(.success([])) }.eraseToAnyPublisher()
            }
            return nextWorker.doLoadTabs(with: progress)
        },
                                  doWork: {
            return self.intDoLoadTabs(with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAdminPubAString
    }
    public func doRequestChange(to role: DNSUserRole,
                                with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubVoid {
        // swiftlint:disable:next force_try
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLAdminFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return nextWorker.doRequestChange(to: role, with: progress)
        },
                                  doWork: {
            return self.intDoRequestChange(to: role, with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAdminPubVoid
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doChange(_ user: DAOUser,
                         to role: DNSUserRole) -> WKRPTCLAdminPubVoid {
        return self.doChange(user, to: role, with: nil)
    }
    public func doCheckAdmin() -> WKRPTCLAdminPubBool {
        return self.doCheckAdmin(with: nil)
    }
    public func doDenyChangeRequest(for user: DAOUser) -> WKRPTCLAdminPubVoid {
        return self.doDenyChangeRequest(for: user, with: nil)
    }
    public func doLoadChangeRequests() -> WKRPTCLAdminPubUserChangeRequest {
        return self.doLoadChangeRequests(with: nil)
    }
    public func doLoadTabs() -> WKRPTCLAdminPubAString {
        return self.doLoadTabs(with: nil)
    }
    public func doRequestChange(to role: DNSUserRole) -> WKRPTCLAdminPubVoid {
        return self.doRequestChange(to: role, with: nil)
    }

    // MARK: - Internal Work Methods
    open func intDoChange(_ user: DAOUser,
                          to role: DNSUserRole,
                          with progress: DNSPTCLProgressBlock?,
                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubVoid {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! WKRPTCLAdminPubVoid
    }
    open func intDoCheckAdmin(with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubBool {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! WKRPTCLAdminPubBool
    }
    open func intDoDenyChangeRequest(for user: DAOUser,
                                     with progress: DNSPTCLProgressBlock?,
                                     then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubVoid {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! WKRPTCLAdminPubVoid
    }
    open func intDoLoadChangeRequests(with progress: DNSPTCLProgressBlock?,
                                      then resultBlock: DNSPTCLResultBlock?) ->
    WKRPTCLAdminPubUserChangeRequest {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! WKRPTCLAdminPubUserChangeRequest
    }
    open func intDoLoadTabs(with progress: DNSPTCLProgressBlock?,
                            then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubAString {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! WKRPTCLAdminPubAString
    }
    open func intDoRequestChange(to role: DNSUserRole,
                                 with progress: DNSPTCLProgressBlock?,
                                 then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubVoid {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! WKRPTCLAdminPubVoid
    }
}
