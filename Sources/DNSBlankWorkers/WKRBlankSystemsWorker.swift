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

open class WKRBlankSystemsWorker: WKRBlankBaseWorker, PTCLSystems
{
    public var callNextWhen: PTCLProtocol.Call.NextWhen = .whenUnhandled
    public var nextWorker: PTCLSystems?

    public required init() {
        super.init()
    }
    public func register(nextWorker: PTCLSystems,
                         for callNextWhen: PTCLProtocol.Call.NextWhen) {
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

    // MARK: - Protocol Interface Methods
    public func doLoadSystem(for id: String,
                             with progress: PTCLProgressBlock?,
                             and block: PTCLSystemsBlockVoidSystem?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadSystem(for: id, with: progress, and: block)
        },
                       doWork: {
            return try self.intDoLoadSystem(for: id, with: progress, and: block, then: $0)
        })
    }

    public func doLoadEndPoints(for system: DAOSystem,
                                with progress: PTCLProgressBlock?,
                                and block: PTCLSystemsBlockVoidArraySystemEndPoint?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadEndPoints(for: system, with: progress, and: block)
        },
                       doWork: {
            return try self.intDoLoadEndPoints(for: system, with: progress, and: block, then: $0)
        })
    }
    public func doLoadHistory(for system: DAOSystem,
                              with progress: PTCLProgressBlock?,
                              and block: PTCLSystemsBlockVoidArraySystemState?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadHistory(for: system, with: progress, and: block)
        },
                       doWork: {
            return try self.intDoLoadHistory(for: system, with: progress, and: block, then: $0)
        })
    }
    public func doLoadSystems(with progress: PTCLProgressBlock?,
                              and block: PTCLSystemsBlockVoidArraySystem?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadSystems(with: progress, and: block)
        },
                       doWork: {
            return try self.intDoLoadSystems(with: progress, and: block, then: $0)
        })
    }
    public func doReport(state: String,
                         for systemId: String,
                         and endPointId: String,
                         with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doReport(state: state,
                                       for: systemId,
                                       and: endPointId,
                                       with: progress)
        },
                               doWork: {
            return self.intDoReport(state: state, for: systemId, and: endPointId, with: progress, then: $0)
        }) as! AnyPublisher<Bool, Error>
    }

    // MARK: - Internal Work Methods
    open func intDoLoadSystem(for id: String,
                               with progress: PTCLProgressBlock?,
                               and block: PTCLSystemsBlockVoidSystem?,
                               then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadEndPoints(for system: DAOSystem,
                                 with progress: PTCLProgressBlock?,
                                 and block: PTCLSystemsBlockVoidArraySystemEndPoint?,
                                 then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadHistory(for system: DAOSystem,
                               with progress: PTCLProgressBlock?,
                               and block: PTCLSystemsBlockVoidArraySystemState?,
                               then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadSystems(with progress: PTCLProgressBlock?,
                               and block: PTCLSystemsBlockVoidArraySystem?,
                               then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoReport(state: String,
                          for systemId: String,
                          and endPointId: String,
                          with progress: PTCLProgressBlock?,
                          then resultBlock: PTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
}
