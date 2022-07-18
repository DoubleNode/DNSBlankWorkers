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
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLSystems?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLSystems,
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
    public func doLoadSystem(for id: String,
                             with progress: DNSPTCLProgressBlock?,
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
                                with progress: DNSPTCLProgressBlock?,
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
                              with progress: DNSPTCLProgressBlock?,
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
                              with progress: DNSPTCLProgressBlock?,
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
    public func doLoadSystems(with progress: DNSPTCLProgressBlock?,
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
                           with progress: DNSPTCLProgressBlock?,
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
                         with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
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
                         with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
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
                         with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
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

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadSystem(for id: String,
                             with block: WKRPTCLSystemsBlockSystem?) throws {
        try self.doLoadSystem(for: id, with: nil, and: block)
    }
    public func doLoadEndPoints(for system: DAOSystem,
                                with block: WKRPTCLSystemsBlockArraySystemEndPoint?) throws {
        try self.doLoadEndPoints(for: system, with: nil, and: block)
    }
    public func doLoadHistory(for system: DAOSystem,
                              since time: Date,
                              with block: WKRPTCLSystemsBlockArraySystemState?) throws {
        try self.doLoadHistory(for: system, since: time, with: nil, and: block)
    }
    public func doLoadHistory(for endPoint: DAOSystemEndPoint,
                              since time: Date,
                              include failureCodes: Bool,
                              with block: WKRPTCLSystemsBlockArraySystemState?) throws {
        try self.doLoadHistory(for: endPoint, since: time, include: failureCodes, with: nil, and: block)
    }
    public func doLoadSystems(with block: WKRPTCLSystemsBlockArraySystem?) throws {
        try self.doLoadSystems(with: nil, and: block)
    }
    public func doOverride(system: DAOSystem,
                           with state: DNSSystemState,
                           with block: WKRPTCLSystemsBlockSystem?) throws {
        try self.doOverride(system: system, with: state, with: nil, and: block)
    }
    public func doReport(result: WKRPTCLSystemsData.Result,
                         for systemId: String,
                         and endPointId: String) -> AnyPublisher<Bool, Error> {
        return self.doReport(result: result, and: "", and: "",
                             for: systemId, and: endPointId, with: nil)
    }
    public func doReport(result: WKRPTCLSystemsData.Result,
                         and failureCode: String,
                         for systemId: String,
                         and endPointId: String) -> AnyPublisher<Bool, Error> {
        return self.doReport(result: result, and: failureCode, and: "",
                             for: systemId, and: endPointId, with: nil)
    }
    public func doReport(result: WKRPTCLSystemsData.Result,
                         and failureCode: String,
                         and debugString: String,
                         for systemId: String,
                         and endPointId: String) -> AnyPublisher<Bool, Error> {
        return self.doReport(result: result, and: failureCode, and: debugString,
                             for: systemId, and: endPointId, with: nil)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadSystem(for id: String,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLSystemsBlockSystem?,
                              then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadEndPoints(for system: DAOSystem,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLSystemsBlockArraySystemEndPoint?,
                                 then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadHistory(for system: DAOSystem,
                               since time: Date,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLSystemsBlockArraySystemState?,
                               then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadHistory(for endPoint: DAOSystemEndPoint,
                               since time: Date,
                               include failureCodes: Bool,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLSystemsBlockArraySystemState?,
                               then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadSystems(with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLSystemsBlockArraySystem?,
                               then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoOverride(system: DAOSystem,
                            with state: DNSSystemState,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLSystemsBlockSystem?,
                            then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoReport(result: WKRPTCLSystemsData.Result,
                          and failureCode: String,
                          and debugString: String,
                          for systemId: String,
                          and endPointId: String,
                          with progress: DNSPTCLProgressBlock?,
                          then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
}
