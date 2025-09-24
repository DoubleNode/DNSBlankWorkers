//
//  WKRBaseAdmin.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import DNSDataTypes
import DNSError
import DNSProtocols
import Foundation

open class WKRBaseAdmin: WKRBaseWorker, WKRPTCLAdmin {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAdmin? {
        get { return nextBaseWorker as? WKRPTCLAdmin }
        set { nextBaseWorker = newValue }
    }

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
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    @discardableResult
    public func runDoPub(runNext: DNSPTCLCallBlock?,
                         doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
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
            guard self.nextWorker != nil else {
                return WKRPTCLAdminFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return self.nextWorker?.doChange(user, to: role, with: progress)
        },
                             doWork: {
            return self.intDoChange(user, to: role, with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAdminPubVoid
    }
    public func doCheckAdmin(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubBool {
        // swiftlint:disable:next force_try
        return self.runDoPub(runNext: {
            guard self.nextWorker != nil else {
                return WKRPTCLAdminFutBool { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return self.nextWorker?.doCheckAdmin(with: progress)
        },
                             doWork: {
            return self.intDoCheckAdmin(with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAdminPubBool
    }
    public func doCompleteDeleted(account: DAOAccount,
                                  with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubVoid {
        // swiftlint:disable:next force_try
        return self.runDoPub(runNext: {
            guard self.nextWorker != nil else {
                return WKRPTCLAdminFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return self.nextWorker?.doCompleteDeleted(account: account, with: progress)
        },
                             doWork: {
            return self.intDoCompleteDeleted(account: account, with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAdminPubVoid
    }
    public func doDenyChangeRequest(for user: DAOUser,
                                    with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubVoid {
        // swiftlint:disable:next force_try
        return self.runDoPub(runNext: {
            guard self.nextWorker != nil else {
                return WKRPTCLAdminFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return self.nextWorker?.doDenyChangeRequest(for: user, with: progress)
        },
                             doWork: {
            return self.intDoDenyChangeRequest(for: user, with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAdminPubVoid
    }
    public func doLoadChangeRequests(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubUserChangeRequest {
        // swiftlint:disable:next force_try
        return self.runDoPub(runNext: {
            guard self.nextWorker != nil else {
                // swiftlint:disable:next line_length
                return WKRPTCLAdminFutUserChangeRequest { $0(.success((nil, []))) }.eraseToAnyPublisher()
            }
            return self.nextWorker?.doLoadChangeRequests(with: progress)
        },
                             doWork: {
            return self.intDoLoadChangeRequests(with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAdminPubUserChangeRequest
    }
    public func doLoadDeletedAccounts(thatAre state: DNSPTCLDeletedStates,
                                      with progress: DNSPTCLProgressBlock?,
                                      and block: WKRPTCLAdminBlkADeletedAccount?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadDeletedAccounts(thatAre: state, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadDeletedAccounts(thatAre: state, with: progress, and: block, then: $0)
        })
    }
    public func doLoadDeletedStatus(with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLAdminBlkDeletedStatus?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadDeletedStatus(with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadDeletedStatus(with: progress, and: block, then: $0)
        })
    }
    public func doLoadTabs(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAdminPubAString {
        // swiftlint:disable:next force_try
        return self.runDoPub(runNext: {
            guard self.nextWorker != nil else {
                return WKRPTCLAdminFutAString { $0(.success([])) }.eraseToAnyPublisher()
            }
            return self.nextWorker?.doLoadTabs(with: progress)
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
            guard self.nextWorker != nil else {
                return WKRPTCLAdminFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return self.nextWorker?.doRequestChange(to: role, with: progress)
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
    public func doCompleteDeleted(account: DAOAccount) -> WKRPTCLAdminPubVoid {
        return self.doCompleteDeleted(account: account, with: nil)
    }
    public func doDenyChangeRequest(for user: DAOUser) -> WKRPTCLAdminPubVoid {
        return self.doDenyChangeRequest(for: user, with: nil)
    }
    public func doLoadChangeRequests() -> WKRPTCLAdminPubUserChangeRequest {
        return self.doLoadChangeRequests(with: nil)
    }
    public func doLoadDeletedAccounts(thatAre state: DNSPTCLDeletedStates,
                                      with block: WKRPTCLAdminBlkADeletedAccount?) {
        self.doLoadDeletedAccounts(thatAre: state, with: nil, and: block)
    }
    public func doLoadDeletedStatus(with block: WKRPTCLAdminBlkDeletedStatus?) {
        self.doLoadDeletedStatus(with: nil, and: block)
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
        return resultBlock?(.unhandled) as! WKRPTCLAdminPubVoid // swiftlint:disable:this force_cast
    }
    open func intDoCheckAdmin(with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubBool {
        return resultBlock?(.unhandled) as! WKRPTCLAdminPubBool // swiftlint:disable:this force_cast
    }
    open func intDoCompleteDeleted(account: DAOAccount,
                                   with progress: DNSPTCLProgressBlock?,
                                   then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubVoid {
        return resultBlock?(.unhandled) as! WKRPTCLAdminPubVoid // swiftlint:disable:this force_cast
    }
    open func intDoDenyChangeRequest(for user: DAOUser,
                                     with progress: DNSPTCLProgressBlock?,
                                     then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubVoid {
        return resultBlock?(.unhandled) as! WKRPTCLAdminPubVoid // swiftlint:disable:this force_cast
    }
    open func intDoLoadChangeRequests(with progress: DNSPTCLProgressBlock?,
                                      // swiftlint:disable:next line_length
                                      then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubUserChangeRequest {
        return resultBlock?(.unhandled) as! WKRPTCLAdminPubUserChangeRequest // swiftlint:disable:this force_cast
    }
    open func intDoLoadDeletedAccounts(thatAre state: DNSPTCLDeletedStates,
                                       with progress: DNSPTCLProgressBlock?,
                                       and block: WKRPTCLAdminBlkADeletedAccount?,
                                       then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadDeletedStatus(with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLAdminBlkDeletedStatus?,
                                     then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadTabs(with progress: DNSPTCLProgressBlock?,
                            then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubAString {
        return resultBlock?(.unhandled) as! WKRPTCLAdminPubAString // swiftlint:disable:this force_cast
    }
    open func intDoRequestChange(to role: DNSUserRole,
                                 with progress: DNSPTCLProgressBlock?,
                                 then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAdminPubVoid {
        return resultBlock?(.unhandled) as! WKRPTCLAdminPubVoid // swiftlint:disable:this force_cast
    }
}
