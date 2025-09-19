//
//  WKRBlankActivityTypes.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import DNSDataTypes
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankActivityTypes: WKRBlankBase, WKRPTCLActivityTypes {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled

    public var nextWKRPTCLActivityTypes: WKRPTCLActivityTypes? {
        get { return nextWorker as? WKRPTCLActivityTypes }
        set { nextWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLActivityTypes,
                         for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.callNextWhen = callNextWhen
        self.nextWKRPTCLActivityTypes = nextWorker
    }

    override open func disableOption(_ option: String) {
        super.disableOption(option)
        nextWKRPTCLActivityTypes?.disableOption(option)
    }
    override open func enableOption(_ option: String) {
        super.enableOption(option)
        nextWKRPTCLActivityTypes?.enableOption(option)
    }
    @discardableResult
    public func runDo(runNext: DNSPTCLCallBlock?,
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWKRPTCLActivityTypes != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.ActivityTypes.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadActivityType(for code: String,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLActivityTypesBlkActivityType?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLActivityTypes?.doLoadActivityType(for: code,
                                                       with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadActivityType(for: code,
                                              with: progress, and: block, then: $0)
        })
    }
    public func doLoadActivityType(for tag: DNSString,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLActivityTypesBlkActivityType?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLActivityTypes?.doLoadActivityType(for: tag,
                                                       with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadActivityType(for: tag,
                                              with: progress, and: block, then: $0)
        })
    }
    public func doLoadActivityTypes(with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLActivityTypesBlkAActivityType?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLActivityTypes?.doLoadActivityTypes(with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadActivityTypes(with: progress, and: block, then: $0)
        })
    }
    public func doLoadPricing(for activityType: DAOActivityType,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLActivityTypesBlkPricing?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLActivityTypes?.doLoadPricing(for: activityType,
                                                  with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadPricing(for: activityType,
                                         with: progress, and: block, then: $0)
        })
    }
    public func doReact(with reaction: DNSReactionType,
                        to activityType: DAOActivityType,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLActivityTypesBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLActivityTypes?.doReact(with: reaction,
                                            to: activityType,
                                            with: progress, and: block)
        },
                   doWork: {
            return self.intDoReact(with: reaction,
                                   to: activityType,
                                   with: progress, and: block, then: $0)
        })
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to activityType: DAOActivityType,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLActivityTypesBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLActivityTypes?.doUnreact(with: reaction,
                                              to: activityType,
                                              with: progress, and: block)
        },
                   doWork: {
            return self.intDoUnreact(with: reaction,
                                     to: activityType,
                                     with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ activityType: DAOActivityType,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLActivityTypesBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLActivityTypes?.doUpdate(activityType, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(activityType, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ pricing: DAOPricing,
                         for activityType: DAOActivityType,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLActivityTypesBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLActivityTypes?.doUpdate(pricing,
                                             for: activityType,
                                             with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(pricing,
                                    for: activityType,
                                    with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadActivityType(for code: String,
                                   with block: WKRPTCLActivityTypesBlkActivityType?) {
        self.doLoadActivityType(for: code, with: nil, and: block)
    }
    public func doLoadActivityType(for tag: DNSString,
                                   with block: WKRPTCLActivityTypesBlkActivityType?) {
        self.doLoadActivityType(for: tag, with: nil, and: block)
    }
    public func doLoadActivityTypes(with block: WKRPTCLActivityTypesBlkAActivityType?) {
        self.doLoadActivityTypes(with: nil, and: block)
    }
    public func doLoadPricing(for activityType: DAOActivityType,
                              with block: WKRPTCLActivityTypesBlkPricing?) {
        self.doLoadPricing(for: activityType, with: nil, and: block)
    }
    public func doReact(with reaction: DNSReactionType,
                        to activityType: DAOActivityType,
                        with block: WKRPTCLActivityTypesBlkMeta?) {
        self.doReact(with: reaction, to: activityType, with: nil, and: block)
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to activityType: DAOActivityType,
                          with block: WKRPTCLActivityTypesBlkMeta?) {
        self.doUnreact(with: reaction, to: activityType, with: nil, and: block)
    }
    public func doUpdate(_ activityType: DAOActivityType,
                         with block: WKRPTCLActivityTypesBlkVoid?) {
        self.doUpdate(activityType, with: nil, and: block)
    }
    public func doUpdate(_ pricing: DAOPricing,
                         for activityType: DAOActivityType,
                         with block: WKRPTCLActivityTypesBlkVoid?) {
        self.doUpdate(pricing, for: activityType, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadActivityType(for code: String,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLActivityTypesBlkActivityType?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOActivityType()))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadActivityType(for tag: DNSString,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLActivityTypesBlkActivityType?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOActivityType()))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadActivityTypes(with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLActivityTypesBlkAActivityType?,
                                     then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadPricing(for activityType: DAOActivityType,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLActivityTypesBlkPricing?,
                               then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOPricing()))
        _ = resultBlock?(.completed)
    }
    open func intDoReact(with reaction: DNSReactionType,
                        to activityType: DAOActivityType,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLActivityTypesBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    open func intDoUnreact(with reaction: DNSReactionType,
                          to activityType: DAOActivityType,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLActivityTypesBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    open func intDoUpdate(_ activityType: DAOActivityType,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLActivityTypesBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoUpdate(_ pricing: DAOPricing,
                          for activityType: DAOActivityType,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLActivityTypesBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
