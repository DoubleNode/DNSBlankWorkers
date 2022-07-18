//
//  WKRBlankAdminWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import DNSProtocols
import Foundation

open class WKRBlankAdminWorker: WKRBlankBaseWorker, WKRPTCLAdmin {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAdmin?

    public required init() {
        super.init()
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
                      doWork: DNSPTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doChange(_ user: DAOUser,
                         to role: DNSUserRole,
                         with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        // swiftlint:disable:next force_try
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doChange(user, to: role, with: progress)
        },
        doWork: {
            return self.intDoChange(user, to: role, with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! AnyPublisher<Bool, Error>
    }
    public func doCheckAdmin(with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        // swiftlint:disable:next force_try
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doCheckAdmin(with: progress)
        },
        doWork: {
            return self.intDoCheckAdmin(with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! AnyPublisher<Bool, Error>
    }
    public func doDenyChangeRequest(for user: DAOUser,
                                    with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        // swiftlint:disable:next force_try
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doDenyChangeRequest(for: user, with: progress)
        },
                               doWork: {
            return self.intDoDenyChangeRequest(for: user, with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! AnyPublisher<Bool, Error>
    }
    public func doLoadChangeRequests(with progress: DNSPTCLProgressBlock?) ->
        AnyPublisher<(DAOUserChangeRequest?, [DAOUserChangeRequest]), Error> {
        // swiftlint:disable:next force_try
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                // swiftlint:disable:next line_length
                return Future<(DAOUserChangeRequest?, [DAOUserChangeRequest]), Error> { $0(.success((nil, []))) }.eraseToAnyPublisher()
            }
            return nextWorker.doLoadChangeRequests(with: progress)
        },
                               doWork: {
            return self.intDoLoadChangeRequests(with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! AnyPublisher<(DAOUserChangeRequest?, [DAOUserChangeRequest]), Error>
    }
    public func doLoadTabs(with progress: DNSPTCLProgressBlock?) -> AnyPublisher<[String], Error> {
        // swiftlint:disable:next force_try
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<[String], Error> { $0(.success([])) }.eraseToAnyPublisher()
            }
            return nextWorker.doLoadTabs(with: progress)
        },
                               doWork: {
            return self.intDoLoadTabs(with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! AnyPublisher<[String], Error>
    }
    public func doRequestChange(to role: DNSUserRole,
                                with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        // swiftlint:disable:next force_try
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doRequestChange(to: role, with: progress)
        },
                               doWork: {
            return self.intDoRequestChange(to: role, with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! AnyPublisher<Bool, Error>
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doChange(_ user: DAOUser,
                         to role: DNSUserRole) -> AnyPublisher<Bool, Error> {
        return self.doChange(user, to: role, with: nil)
    }
    public func doCheckAdmin() -> AnyPublisher<Bool, Error> {
        return self.doCheckAdmin(with: nil)
    }
    public func doDenyChangeRequest(for user: DAOUser) -> AnyPublisher<Bool, Error> {
        return self.doDenyChangeRequest(for: user, with: nil)
    }
    public func doLoadChangeRequests() -> AnyPublisher<(DAOUserChangeRequest?, [DAOUserChangeRequest]), Error> {
        return self.doLoadChangeRequests(with: nil)
    }
    public func doLoadTabs() -> AnyPublisher<[String], Error> {
        return self.doLoadTabs(with: nil)
    }
    public func doRequestChange(to role: DNSUserRole) -> AnyPublisher<Bool, Error> {
        return self.doRequestChange(to: role, with: nil)
    }

    // MARK: - Internal Work Methods
    open func intDoChange(_ user: DAOUser,
                          to role: DNSUserRole,
                          with progress: DNSPTCLProgressBlock?,
                          then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
    open func intDoCheckAdmin(with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
    open func intDoDenyChangeRequest(for user: DAOUser,
                                     with progress: DNSPTCLProgressBlock?,
                                     then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
    open func intDoLoadChangeRequests(with progress: DNSPTCLProgressBlock?,
                                      then resultBlock: DNSPTCLResultBlock?) ->
    AnyPublisher<(DAOUserChangeRequest?, [DAOUserChangeRequest]), Error> {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! AnyPublisher<(DAOUserChangeRequest?, [DAOUserChangeRequest]), Error>
    }
    open func intDoLoadTabs(with progress: DNSPTCLProgressBlock?,
                            then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<[String], Error> {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! AnyPublisher<[String], Error>
    }
    open func intDoRequestChange(to role: DNSUserRole,
                                 with progress: DNSPTCLProgressBlock?,
                                 then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
}
