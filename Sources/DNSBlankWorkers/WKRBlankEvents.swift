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
    public func doLoadCurrentEvents(with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLEventsBlkAPlace?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadCurrentEvents(with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadCurrentEvents(with: progress, and: block, then: $0)
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
    public func doLoadPricing(for event: DAOEvent,
                              and place: DAOPlace,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLEventsBlkPricing?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadPricing(for: event,
                                                  and: place,
                                                  with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadPricing(for: event, and: place,
                                         with: progress, and: block, then: $0)
        })
    }
    public func doReact(with reaction: DNSReactionType,
                        to event: DAOEvent,
                        for place: DAOPlace,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLEventsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doReact(with: reaction, to: event, for: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoReact(with: reaction, to: event, for: place, with: progress, and: block, then: $0)
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
    public func doRemove(_ eventDay: DAOEventDay,
                         for event: DAOEvent,
                         and place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLEventsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRemove(eventDay, for: event, and: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoRemove(eventDay, for: event, and: place, with: progress, and: block, then: $0)
        })
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to event: DAOEvent,
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLEventsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUnreact(with: reaction, to: event, for: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUnreact(with: reaction, to: event, for: place, with: progress, and: block, then: $0)
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
    public func doUpdate(_ eventDay: DAOEventDay,
                         for event: DAOEvent,
                         and place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLEventsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(eventDay, for: event, and: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(eventDay, for: event, and: place, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ pricing: DAOPricing,
                         for event: DAOEvent,
                         and place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLEventsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(pricing, for: event, and: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(pricing, for: event, and: place, with: progress, and: block, then: $0)
        })
    }
    public func doView(_ event: DAOEvent,
                       for place: DAOPlace,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLEventsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doView(event, for: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoView(event, for: place, with: progress, and: block, then: $0)
        })
    }


    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadCurrentEvents(with block: WKRPTCLEventsBlkAPlace?) {
        self.doLoadCurrentEvents(with: nil, and: block)
    }
    public func doLoadEvents(for place: DAOPlace,
                             with block: WKRPTCLEventsBlkAEvent?) {
        self.doLoadEvents(for: place, with: nil, and: block)
    }
    public func doLoadPricing(for event: DAOEvent,
                              and place: DAOPlace,
                              with block: WKRPTCLEventsBlkPricing?) {
        self.doLoadPricing(for: event, and: place, with: nil, and: block)
    }
    public func doReact(with reaction: DNSReactionType,
                        to event: DAOEvent,
                        for place: DAOPlace,
                        with block: WKRPTCLEventsBlkMeta?) {
        self.doReact(with: reaction, to: event, for: place, with: nil, and: block)
    }
    public func doRemove(_ event: DAOEvent,
                         for place: DAOPlace,
                         with block: WKRPTCLEventsBlkVoid?) {
        self.doRemove(event, for: place, with: nil, and: block)
    }
    public func doRemove(_ eventDay: DAOEventDay,
                         for event: DAOEvent,
                         and place: DAOPlace,
                         with block: WKRPTCLEventsBlkVoid?) {
        self.doRemove(eventDay, for: event, and: place, with: nil, and: block)
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to event: DAOEvent,
                          for place: DAOPlace,
                          with block: WKRPTCLEventsBlkMeta?) {
        self.doUnreact(with: reaction, to: event, for: place, with: nil, and: block)
    }
    public func doUpdate(_ event: DAOEvent,
                         for place: DAOPlace,
                         with block: WKRPTCLEventsBlkVoid?) {
        self.doUpdate(event, for: place, with: nil, and: block)
    }
    public func doUpdate(_ eventDay: DAOEventDay,
                         for event: DAOEvent,
                         and place: DAOPlace,
                         with block: WKRPTCLEventsBlkVoid?) {
        self.doUpdate(eventDay, for: event, and: place, with: nil, and: block)
    }
    public func doUpdate(_ pricing: DAOPricing,
                         for event: DAOEvent,
                         and place: DAOPlace,
                         with block: WKRPTCLEventsBlkVoid?) {
        self.doUpdate(pricing, for: event, and: place, with: nil, and: block)
    }
    public func doView(_ event: DAOEvent,
                       for place: DAOPlace,
                       with block: WKRPTCLEventsBlkMeta?) {
        self.doView(event, for: place, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadCurrentEvents(with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLEventsBlkAPlace?,
                                     then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadEvents(for place: DAOPlace,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLEventsBlkAEvent?,
                              then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadPricing(for event: DAOEvent,
                               and place: DAOPlace,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLEventsBlkPricing?,
                               then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoReact(with reaction: DNSReactionType,
                         to event: DAOEvent,
                         for place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLEventsBlkMeta?,
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
    open func intDoRemove(_ eventDay: DAOEventDay,
                          for event: DAOEvent,
                          and place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLEventsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUnreact(with reaction: DNSReactionType,
                           to event: DAOEvent,
                           for place: DAOPlace,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLEventsBlkMeta?,
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
    open func intDoUpdate(_ eventDay: DAOEventDay,
                          for event: DAOEvent,
                          and place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLEventsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ pricing: DAOPricing,
                          for event: DAOEvent,
                          and place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLEventsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoView(_ event: DAOEvent,
                        for place: DAOPlace,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLEventsBlkMeta?,
                        then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
