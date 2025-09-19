//
//  WKRBlankSystems.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSDataObjects
import DNSDataTypes
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankSystems: WKRBlankBase, WKRPTCLSystems {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled

    public var nextWKRPTCLSystems: WKRPTCLSystems? {
        get { return nextWorker as? WKRPTCLSystems }
        set { nextWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = self
    }
    public func register(nextWorker: WKRPTCLSystems,
                         for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.callNextWhen = callNextWhen
        self.nextWKRPTCLSystems = nextWorker
    }

    override open func disableOption(_ option: String) {
        super.disableOption(option)
        nextWKRPTCLSystems?.disableOption(option)
    }
    override open func enableOption(_ option: String) {
        super.enableOption(option)
        nextWKRPTCLSystems?.enableOption(option)
    }
    @discardableResult
    public func runDo(runNext: DNSPTCLCallBlock?,
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWKRPTCLSystems != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Systems.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doConfigure(with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLSystemsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLSystems?.doConfigure(with: progress, and: block)
        },
                   doWork: {
            return self.intDoConfigure(with: progress, and: block, then: $0)
        })
    }
    public func doLoadSystem(for id: String,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLSystemsBlkSystem?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLSystems?.doLoadSystem(for: id, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadSystem(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadEndPoints(for system: DAOSystem,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLSystemsBlkASystemEndPoint?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLSystems?.doLoadEndPoints(for: system, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadEndPoints(for: system, with: progress, and: block, then: $0)
        })
    }
    public func doLoadHistory(for system: DAOSystem,
                              since time: Date,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLSystemsBlkASystemState?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLSystems?.doLoadHistory(for: system, since: time,
                                                      with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadHistory(for: system, since: time,
                                             with: progress, and: block, then: $0)
        })
    }
    public func doLoadHistory(for endPoint: DAOSystemEndPoint,
                              since time: Date,
                              include failureCodes: Bool,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLSystemsBlkASystemState?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLSystems?.doLoadHistory(for: endPoint, since: time, include: failureCodes,
                                                      with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadHistory(for: endPoint, since: time, include: failureCodes,
                                             with: progress, and: block, then: $0)
        })
    }
    public func doLoadSystems(with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLSystemsBlkASystem?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLSystems?.doLoadSystems(with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadSystems(with: progress, and: block, then: $0)
        })
    }
    public func doOverride(system: DAOSystem,
                           with state: DNSSystemState,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLSystemsBlkSystem?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLSystems?.doOverride(system: system, with: state,
                                                   with: progress, and: block)
        },
                   doWork: {
            return self.intDoOverride(system: system, with: state, with: progress, and: block, then: $0)
        })
    }
    public func doReact(with reaction: DNSReactionType,
                        to system: DAOSystem,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLSystemsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLSystems?.doReact(with: reaction, to: system, with: progress, and: block)
        },
                   doWork: {
            return self.intDoReact(with: reaction, to: system, with: progress, and: block, then: $0)
        })
    }
    public func doReport(result: WKRPTCLSystemsData.Result,
                         for systemId: String,
                         and endPointId: String,
                         with progress: DNSPTCLProgressBlock?) -> WKRPTCLSystemsPubVoid {
        return doReport(result: result, and: "", and: "",
                        for: systemId, and: endPointId, with: progress)
    }
    public func doReport(result: WKRPTCLSystemsData.Result,
                         and failureCode: String,
                         for systemId: String,
                         and endPointId: String,
                         with progress: DNSPTCLProgressBlock?) -> WKRPTCLSystemsPubVoid {
        return doReport(result: result, and: failureCode, and: "",
                        for: systemId, and: endPointId, with: progress)
    }
    public func doReport(result: WKRPTCLSystemsData.Result,
                         and failureCode: String,
                         and debugString: String,
                         for systemId: String,
                         and endPointId: String,
                         with progress: DNSPTCLProgressBlock?) -> WKRPTCLSystemsPubVoid {
        return self.runDo(runNext: {
            guard self.nextWorker != nil else {
                return WKRPTCLSystemsFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return self.nextWKRPTCLSystems?.doReport(result: result, and: failureCode, and: debugString,
                                       for: systemId, and: endPointId, with: progress)
        },
                           doWork: {
            return self.intDoReport(result: result, and: failureCode, and: debugString,
                                    for: systemId, and: endPointId,
                                    with: progress, then: $0)
        }) as! WKRPTCLSystemsPubVoid // swiftlint:disable:this force_cast
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to system: DAOSystem,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLSystemsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLSystems?.doUnreact(with: reaction, to: system, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUnreact(with: reaction, to: system, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doConfigure(and block: WKRPTCLSystemsBlkVoid?) {
        self.doConfigure(with: nil, and: block)
    }
    public func doLoadSystem(for id: String,
                             with block: WKRPTCLSystemsBlkSystem?) {
        self.doLoadSystem(for: id, with: nil, and: block)
    }
    public func doLoadEndPoints(for system: DAOSystem,
                                with block: WKRPTCLSystemsBlkASystemEndPoint?) {
        self.doLoadEndPoints(for: system, with: nil, and: block)
    }
    public func doLoadHistory(for system: DAOSystem,
                              since time: Date,
                              with block: WKRPTCLSystemsBlkASystemState?) {
        self.doLoadHistory(for: system, since: time, with: nil, and: block)
    }
    public func doLoadHistory(for endPoint: DAOSystemEndPoint,
                              since time: Date,
                              include failureCodes: Bool,
                              with block: WKRPTCLSystemsBlkASystemState?) {
        self.doLoadHistory(for: endPoint, since: time, include: failureCodes, with: nil, and: block)
    }
    public func doLoadSystems(with block: WKRPTCLSystemsBlkASystem?) {
        self.doLoadSystems(with: nil, and: block)
    }
    public func doOverride(system: DAOSystem,
                           with state: DNSSystemState,
                           with block: WKRPTCLSystemsBlkSystem?) {
        self.doOverride(system: system, with: state, with: nil, and: block)
    }
    public func doReact(with reaction: DNSReactionType,
                        to system: DAOSystem,
                        with block: WKRPTCLSystemsBlkMeta?) {
        self.doReact(with: reaction, to: system, with: nil, and: block)
    }
    public func doReport(result: WKRPTCLSystemsData.Result,
                         for systemId: String,
                         and endPointId: String) -> WKRPTCLSystemsPubVoid {
        return self.doReport(result: result, and: "", and: "",
                             for: systemId, and: endPointId, with: nil)
    }
    public func doReport(result: WKRPTCLSystemsData.Result,
                         and failureCode: String,
                         for systemId: String,
                         and endPointId: String) -> WKRPTCLSystemsPubVoid {
        return self.doReport(result: result, and: failureCode, and: "",
                             for: systemId, and: endPointId, with: nil)
    }
    public func doReport(result: WKRPTCLSystemsData.Result,
                         and failureCode: String,
                         and debugString: String,
                         for systemId: String,
                         and endPointId: String) -> WKRPTCLSystemsPubVoid {
        return self.doReport(result: result, and: failureCode, and: debugString,
                             for: systemId, and: endPointId, with: nil)
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to system: DAOSystem,
                          with block: WKRPTCLSystemsBlkMeta?) {
        self.doUnreact(with: reaction, to: system, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoConfigure(with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLSystemsBlkVoid?,
                             then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoLoadSystem(for id: String,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLSystemsBlkSystem?,
                              then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOSystem()))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadEndPoints(for system: DAOSystem,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLSystemsBlkASystemEndPoint?,
                                 then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadHistory(for system: DAOSystem,
                               since time: Date,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLSystemsBlkASystemState?,
                               then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadHistory(for endPoint: DAOSystemEndPoint,
                               since time: Date,
                               include failureCodes: Bool,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLSystemsBlkASystemState?,
                               then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadSystems(with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLSystemsBlkASystem?,
                               then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    open func intDoOverride(system: DAOSystem,
                            with state: DNSSystemState,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLSystemsBlkSystem?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOSystem()))
        _ = resultBlock?(.completed)
    }
    open func intDoReact(with reaction: DNSReactionType,
                         to system: DAOSystem,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLSystemsBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    open func intDoReport(result: WKRPTCLSystemsData.Result,
                          and failureCode: String,
                          and debugString: String,
                          for systemId: String,
                          and endPointId: String,
                          with progress: DNSPTCLProgressBlock?,
                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLSystemsPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLSystemsFutVoid { $0(.success) }.eraseToAnyPublisher()
    }
    open func intDoUnreact(with reaction: DNSReactionType,
                           to system: DAOSystem,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLSystemsBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
}
