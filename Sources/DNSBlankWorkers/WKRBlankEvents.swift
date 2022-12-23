//
//  WKRBlankEvents.swift
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

open class WKRBlankEvents: WKRBlankBase, WKRPTCLEvents {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLEvents?

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLEvents,
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
        if case DNSError.Events.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadEvents(with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLEventsBlkAEvent?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadEvents(with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadEvents(with: progress, and: block, then: $0)
        })
    }
    public func doLoadEvents(for place: DAOPlace,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLEventsBlkAEvent?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadEvents(for: place, with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadEvents(for: place, with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ event: DAOEvent,
                         for place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLEventsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRemove(event, for: place, with: progress, and: block)
        },
        doWork: {
            return self.intDoRemove(event, for: place, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ event: DAOEvent,
                         for place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLEventsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(event, for: place, with: progress, and: block)
        },
        doWork: {
            return self.intDoUpdate(event, for: place, with: progress, and: block, then: $0)
        })
    }


    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadEvents(with block: WKRPTCLEventsBlkAEvent?) {
        self.doLoadEvents(with: nil, and: block)
    }
    public func doLoadEvents(for place: DAOPlace,
                             with block: WKRPTCLEventsBlkAEvent?) {
        self.doLoadEvents(for: place, with: nil, and: block)
    }
    public func doRemove(_ event: DAOEvent,
                         for place: DAOPlace,
                         with block: WKRPTCLEventsBlkVoid?) {
        self.doRemove(event, for: place, with: nil, and: block)
    }
    public func doUpdate(_ event: DAOEvent,
                         for place: DAOPlace,
                         with block: WKRPTCLEventsBlkVoid?) {
        self.doUpdate(event, for: place, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadEvents(with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLEventsBlkAEvent?,
                              then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadEvents(for place: DAOPlace,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLEventsBlkAEvent?,
                              then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemove(_ event: DAOEvent,
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLEventsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ event: DAOEvent,
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLEventsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
