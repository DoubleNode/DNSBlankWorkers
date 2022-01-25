//
//  WKRBlankSystemsStateWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
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
    public func doReportState(of state: String,
                              for system: String,
                              and endPoint: String,
                              with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doReportState(of: state,
                                            for: system,
                                            and: endPoint,
                                            with: progress)
        },
                               doWork: {
            return self.intDoReportState(of: state, for: system, and: endPoint, with: progress, then: $0)
        }) as! AnyPublisher<Bool, Error>
    }

    // MARK: - Internal Work Methods
    open func intDoLoadSystem(for id: String,
                               with progress: PTCLProgressBlock?,
                               and block: PTCLSystemsBlockVoidSystem?,
                               then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadSystems(with progress: PTCLProgressBlock?,
                               and block: PTCLSystemsBlockVoidArraySystem?,
                               then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoReportState(of state: String,
                               for system: String,
                               and endPoint: String,
                               with progress: PTCLProgressBlock?,
                               then resultBlock: PTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
}
