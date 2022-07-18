//
//  WKRBlankSystemsStateWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSDataObjects
import DNSProtocols
import UIKit

open class WKRBlankSystemsWorker: WKRBaseWorker, WKRPTCLSystems {
    public var callNextWhen: WKRPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLSystems?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLSystems,
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
    public func doLoadSystem(for id: String,
                             with progress: WKRPTCLProgressBlock?,
                             and block: WKRPTCLSystemsBlockSystem?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadSystem(for: id, with: progress, and: block)
        },
                       doWork: {
            return try self.intDoLoadSystem(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadEndPoints(for system: DAOSystem,
                                with progress: WKRPTCLProgressBlock?,
                                and block: WKRPTCLSystemsBlockArraySystemEndPoint?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadEndPoints(for: system, with: progress, and: block)
        },
                       doWork: {
            return try self.intDoLoadEndPoints(for: system, with: progress, and: block, then: $0)
        })
    }
    public func doLoadHistory(for system: DAOSystem,
                              since time: Date,
                              with progress: WKRPTCLProgressBlock?,
                              and block: WKRPTCLSystemsBlockArraySystemState?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadHistory(for: system, since: time, with: progress, and: block)
        },
                       doWork: {
            return try self.intDoLoadHistory(for: system, since: time,
                                             with: progress, and: block, then: $0)
        })
    }
    public func doLoadHistory(for endPoint: DAOSystemEndPoint,
                              since time: Date,
                              include failureCodes: Bool,
                              with progress: WKRPTCLProgressBlock?,
                              and block: WKRPTCLSystemsBlockArraySystemState?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadHistory(for: endPoint, since: time, include: failureCodes,
                                                with: progress, and: block)
        },
                       doWork: {
            return try self.intDoLoadHistory(for: endPoint, since: time, include: failureCodes,
                                             with: progress, and: block, then: $0)
        })
    }
    public func doLoadSystems(with progress: WKRPTCLProgressBlock?,
                              and block: WKRPTCLSystemsBlockArraySystem?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadSystems(with: progress, and: block)
        },
                       doWork: {
            return try self.intDoLoadSystems(with: progress, and: block, then: $0)
        })
    }
    public func doOverride(system: DAOSystem,
                           with state: DNSSystemState,
                           with progress: WKRPTCLProgressBlock?,
                           and block: WKRPTCLSystemsBlockSystem?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doOverride(system: system, with: state, with: progress, and: block)
        },
                       doWork: {
            return try self.intDoOverride(system: system, with: state, with: progress, and: block, then: $0)
        })
    }
    public func doReport(result: WKRPTCLSystemsData.Result,
                         for systemId: String,
                         and endPointId: String,
                         with progress: WKRPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        return doReport(result: result,
                        and: "",
                        and: "",
                        for: systemId,
                        and: endPointId,
                        with: progress)
    }
    public func doReport(result: WKRPTCLSystemsData.Result,
                         and failureCode: String,
                         for systemId: String,
                         and endPointId: String,
                         with progress: WKRPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        return doReport(result: result,
                        and: failureCode,
                        and: "",
                        for: systemId,
                        and: endPointId,
                        with: progress)
    }
    public func doReport(result: WKRPTCLSystemsData.Result,
                         and failureCode: String,
                         and debugString: String,
                         for systemId: String,
                         and endPointId: String,
                         with progress: WKRPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doReport(result: result,
                                       and: failureCode,
                                       and: debugString,
                                       for: systemId,
                                       and: endPointId,
                                       with: progress)
        },
                               doWork: {
            return self.intDoReport(result: result, and: failureCode, and: debugString,
                                    for: systemId, and: endPointId,
                                    with: progress, then: $0)
        }) as! AnyPublisher<Bool, Error>
    }

    // MARK: - Internal Work Methods
    open func intDoLoadSystem(for id: String,
                              with progress: WKRPTCLProgressBlock?,
                              and block: WKRPTCLSystemsBlockSystem?,
                              then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadEndPoints(for system: DAOSystem,
                                 with progress: WKRPTCLProgressBlock?,
                                 and block: WKRPTCLSystemsBlockArraySystemEndPoint?,
                                 then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadHistory(for system: DAOSystem,
                               since time: Date,
                               with progress: WKRPTCLProgressBlock?,
                               and block: WKRPTCLSystemsBlockArraySystemState?,
                               then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadHistory(for endPoint: DAOSystemEndPoint,
                               since time: Date,
                               include failureCodes: Bool,
                               with progress: WKRPTCLProgressBlock?,
                               and block: WKRPTCLSystemsBlockArraySystemState?,
                               then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadSystems(with progress: WKRPTCLProgressBlock?,
                               and block: WKRPTCLSystemsBlockArraySystem?,
                               then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoOverride(system: DAOSystem,
                            with state: DNSSystemState,
                            with progress: WKRPTCLProgressBlock?,
                            and block: WKRPTCLSystemsBlockSystem?,
                            then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoReport(result: WKRPTCLSystemsData.Result,
                          and failureCode: String,
                          and debugString: String,
                          for systemId: String,
                          and endPointId: String,
                          with progress: WKRPTCLProgressBlock?,
                          then resultBlock: WKRPTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
}
