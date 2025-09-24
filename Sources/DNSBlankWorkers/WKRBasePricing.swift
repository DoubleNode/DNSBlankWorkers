//
//  WKRBasePricing.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBasePricing: WKRBaseWorker, WKRPTCLPricing {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLPricing? {
        get { return nextBaseWorker as? WKRPTCLPricing }
        set { nextBaseWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLPricing,
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
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Pricing.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadPricingItems(for pricingTier: DAOPricingTier,
                                   and pricingSeason: DAOPricingSeason,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLPricingBlkAPricingItem?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadPricingItems(for: pricingTier, and: pricingSeason,
                                                       with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadPricingItems(for: pricingTier, and: pricingSeason,
                                              with: progress, and: block, then: $0)
        })
    }
    public func doLoadPricingSeasons(for pricingTier: DAOPricingTier,
                                     with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLPricingBlkAPricingSeason?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadPricingSeasons(for: pricingTier, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadPricingSeasons(for: pricingTier, with: progress, and: block, then: $0)
        })
    }
    public func doLoadPricingTiers(with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLPricingBlkAPricingTier?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadPricingTiers(with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadPricingTiers(with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ pricingTier: DAOPricingTier,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPricingBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRemove(pricingTier, with: progress, and: block)
        },
                   doWork: {
            return self.intDoRemove(pricingTier, with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ pricingSeason: DAOPricingSeason,
                         for pricingTier: DAOPricingTier,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPricingBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRemove(pricingSeason, for: pricingTier,
                                             with: progress, and: block)
        },
                   doWork: {
            return self.intDoRemove(pricingSeason, for: pricingTier,
                                    with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ pricingItem: DAOPricingItem,
                         for pricingTier: DAOPricingTier,
                         and pricingSeason: DAOPricingSeason,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPricingBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRemove(pricingItem, for: pricingTier, and: pricingSeason,
                                             with: progress, and: block)
        },
                   doWork: {
            return self.intDoRemove(pricingItem, for: pricingTier, and: pricingSeason,
                                     with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ pricingTier: DAOPricingTier,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPricingBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(pricingTier, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(pricingTier, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ pricingSeason: DAOPricingSeason,
                         for pricingTier: DAOPricingTier,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPricingBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(pricingSeason, for: pricingTier,
                                             with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(pricingSeason, for: pricingTier,
                                    with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ pricingItem: DAOPricingItem,
                         for pricingTier: DAOPricingTier,
                         and pricingSeason: DAOPricingSeason,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPricingBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(pricingItem, for: pricingTier, and: pricingSeason,
                                             with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(pricingItem, for: pricingTier, and: pricingSeason,
                                    with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadPricingItems(for pricingTier: DAOPricingTier,
                                   and pricingSeason: DAOPricingSeason,
                                   with block: WKRPTCLPricingBlkAPricingItem?) {
        self.doLoadPricingItems(for: pricingTier, and: pricingSeason,
                                with: nil, and: block)
    }
    public func doLoadPricingSeasons(for pricingTier: DAOPricingTier,
                                     with block: WKRPTCLPricingBlkAPricingSeason?) {
        self.doLoadPricingSeasons(for: pricingTier, with: nil, and: block)
    }
    public func doLoadPricingTiers(with block: WKRPTCLPricingBlkAPricingTier?) {
        self.doLoadPricingTiers(with: nil, and: block)
    }
    public func doRemove(_ pricingTier: DAOPricingTier,
                         with block: WKRPTCLPricingBlkVoid?) {
        self.doRemove(pricingTier, with: nil, and: block)
    }
    public func doRemove(_ pricingSeason: DAOPricingSeason,
                         for pricingTier: DAOPricingTier,
                         with block: WKRPTCLPricingBlkVoid?) {
        self.doRemove(pricingSeason, for: pricingTier, with: nil, and: block)
    }
    public func doRemove(_ pricingItem: DAOPricingItem,
                         for pricingTier: DAOPricingTier,
                         and pricingSeason: DAOPricingSeason,
                         with block: WKRPTCLPricingBlkVoid?) {
        self.doRemove(pricingItem, for: pricingTier, and: pricingSeason, with: nil, and: block)
    }
    public func doUpdate(_ pricingTier: DAOPricingTier,
                         with block: WKRPTCLPricingBlkVoid?) {
        self.doUpdate(pricingTier, with: nil, and: block)
    }
    public func doUpdate(_ pricingSeason: DAOPricingSeason,
                         for pricingTier: DAOPricingTier,
                         with block: WKRPTCLPricingBlkVoid?) {
        self.doUpdate(pricingSeason, for: pricingTier, with: nil, and: block)
    }
    public func doUpdate(_ pricingItem: DAOPricingItem,
                         for pricingTier: DAOPricingTier,
                         and pricingSeason: DAOPricingSeason,
                         with block: WKRPTCLPricingBlkVoid?) {
        self.doUpdate(pricingItem, for: pricingTier, and: pricingSeason, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadPricingItems(for pricingTier: DAOPricingTier,
                                    and pricingSeason: DAOPricingSeason,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLPricingBlkAPricingItem?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadPricingSeasons(for pricingTier: DAOPricingTier,
                                      with progress: DNSPTCLProgressBlock?,
                                      and block: WKRPTCLPricingBlkAPricingSeason?,
                                      then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadPricingTiers(with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLPricingBlkAPricingTier?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemove(_ pricingTier: DAOPricingTier,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPricingBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemove(_ pricingSeason: DAOPricingSeason,
                          for pricingTier: DAOPricingTier,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPricingBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemove(_ pricingItem: DAOPricingItem,
                          for pricingTier: DAOPricingTier,
                          and pricingSeason: DAOPricingSeason,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPricingBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ pricingTier: DAOPricingTier,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPricingBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ pricingSeason: DAOPricingSeason,
                          for pricingTier: DAOPricingTier,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPricingBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ pricingItem: DAOPricingItem,
                          for pricingTier: DAOPricingTier,
                          and pricingSeason: DAOPricingSeason,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPricingBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
