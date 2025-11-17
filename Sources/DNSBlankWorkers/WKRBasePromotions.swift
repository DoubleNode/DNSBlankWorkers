//
//  WKRBasePromotions.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import DNSDataUIObjects
import DNSDataTypes
import DNSError
import DNSProtocols
import Foundation

open class WKRBasePromotions: WKRBaseWorker, WKRPTCLPromotions {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLPromotions? {
        get { return nextBaseWorker as? WKRPTCLPromotions }
        set { nextBaseWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLPromotions,
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
        if case DNSError.Products.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Base Worker Logic -
    open func doAnalytics(for object: DAOPromotion,
                          using data: DNSDataDictionary,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLWorkerBaseBlkAAnalyticsData?) {
        self.runDo(runNext: {
            return self.nextWorker?.doAnalytics(for: object, using: data, with: progress, and: block)
        },
                   doWork: {
            return self.intDoAnalytics(for: object, using: data, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Public) -
    @available(iOS 15.0.0, *)
    public func doActivate(_ id: String,
                           with progress: DNSPTCLProgressBlock?) async -> WKRPTCLPromotionsResVoid {
        await withCheckedContinuation { continuation in
            doActivate(id, with: progress) { result in
                continuation.resume(returning: result)
            }
        }
    }
    public func doActivate(_ id: String,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLPromotionsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doActivate(id, with: progress, and: block)
        },
                   doWork: {
            return self.intDoActivate(id, with: progress, and: block, then: $0)
        })
    }
    @available(iOS 15.0.0, *)
    public func doDelete(_ promotion: DAOPromotion,
                         with progress: DNSPTCLProgressBlock?) async -> WKRPTCLPromotionsResVoid {
        await withCheckedContinuation { continuation in
            doDelete(promotion, with: progress) { result in
                continuation.resume(returning: result)
            }
        }
    }
    public func doDelete(_ promotion: DAOPromotion,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPromotionsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doDelete(promotion, with: progress, and: block)
        },
        doWork: {
            return self.intDoDelete(promotion, with: progress, and: block, then: $0)
        })
    }
    @available(iOS 15.0.0, *)
    public func doDispense(_ id: String,
                           with progress: DNSPTCLProgressBlock?) async -> WKRPTCLPromotionsResVoid {
        await withCheckedContinuation { continuation in
            doDispense(id, with: progress) { result in
                continuation.resume(returning: result)
            }
        }
    }
    public func doDispense(_ id: String,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLPromotionsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doDispense(id, with: progress, and: block)
        },
                   doWork: {
            return self.intDoDispense(id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadAnalytics(for promotion: DAOPromotion,
                                between startDate: Date?,
                                and endDate: Date?,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLPromotionsBlkPromotionAnalytics?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadAnalytics(for: promotion, between: startDate, and: endDate, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadAnalytics(for: promotion, between: startDate, and: endDate, with: progress, and: block, then: $0)
        })
    }
    public func doLoadPromotion(for id: String,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLPromotionsBlkPromotion?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadPromotion(for: id, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadPromotion(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadPromotions(for account: DAOAccount?,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLPromotionsBlkAPromotion?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadPromotions(for: account, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadPromotions(for: account, with: progress, and: block, then: $0)
        })
    }
    public func doLoadPromotions(for path: String,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLPromotionsBlkAPromotion?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadPromotions(for: path, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadPromotions(for: path, with: progress, and: block, then: $0)
        })
    }
    public func doReact(with reaction: DNSReactionType,
                        to promotion: DAOPromotion,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLPromotionsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doReact(with: reaction, to: promotion, with: progress, and: block)
        },
                   doWork: {
            return self.intDoReact(with: reaction, to: promotion, with: progress, and: block, then: $0)
        })
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to promotion: DAOPromotion,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPromotionsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUnreact(with: reaction, to: promotion, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUnreact(with: reaction, to: promotion, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ promotion: DAOPromotion,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPromotionsBlkPromotion?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(promotion, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(promotion, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    @available(iOS 15.0.0, *)
    public func doActivate(_ id: String) async -> WKRPTCLPromotionsResVoid {
        return await doActivate(id, with: nil)
    }
    public func doActivate(_ id: String,
                           and block: WKRPTCLPromotionsBlkVoid?) {
        self.doActivate(id, with: nil, and: block)
    }
    @available(iOS 15.0.0, *)
    public func doDelete(_ promotion: DAOPromotion) async -> WKRPTCLPromotionsResVoid {
        return await doDelete(promotion, with: nil)
    }
    public func doDelete(_ promotion: DAOPromotion,
                         and block: WKRPTCLPromotionsBlkVoid?) {
        self.doDelete(promotion, with: nil, and: block)
    }
    @available(iOS 15.0.0, *)
    public func doDispense(_ id: String) async -> WKRPTCLPromotionsResVoid {
        return await doDispense(id, with: nil)
    }
    public func doDispense(_ id: String,
                           and block: WKRPTCLPromotionsBlkVoid?) {
        self.doDispense(id, with: nil, and: block)
    }
    public func doLoadAnalytics(for promotion: DAOPromotion,
                                between startDate: Date?,
                                and endDate: Date?,
                                and block: WKRPTCLPromotionsBlkPromotionAnalytics?) {
        self.doLoadAnalytics(for: promotion, between: startDate, and: endDate, with: nil, and: block)
    }
    public func doLoadPromotion(for id: String,
                                and block: WKRPTCLPromotionsBlkPromotion?) {
        self.doLoadPromotion(for: id, with: nil, and: block)
    }
    public func doLoadPromotions(for account: DAOAccount?,
                                 and block: WKRPTCLPromotionsBlkAPromotion?) {
        self.doLoadPromotions(for: account, with: nil, and: block)
    }
    public func doLoadPromotions(for path: String,
                                 and block: WKRPTCLPromotionsBlkAPromotion?) {
        self.doLoadPromotions(for: path, with: nil, and: block)
    }
    public func doReact(with reaction: DNSReactionType,
                        to promotion: DAOPromotion,
                        with block: WKRPTCLPromotionsBlkMeta?) {
        self.doReact(with: reaction, to: promotion, with: nil, and: block)
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to promotion: DAOPromotion,
                          with block: WKRPTCLPromotionsBlkMeta?) {
        self.doUnreact(with: reaction, to: promotion, with: nil, and: block)
    }
    public func doUpdate(_ promotion: DAOPromotion,
                         and block: WKRPTCLPromotionsBlkPromotion?) {
        self.doUpdate(promotion, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoActivate(_ id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLPromotionsBlkVoid?,
                            then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoDelete(_ promotion: DAOPromotion,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPromotionsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoDispense(_ id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLPromotionsBlkVoid?,
                            then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func doLoadAnalytics(for promotion: DAOPromotion,
                              between startDate: Date?,
                              and endDate: Date?,
                              and block: WKRPTCLPromotionsBlkPromotionAnalytics?,
                              then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadPromotion(for id: String,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLPromotionsBlkPromotion?,
                                 then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadPromotions(for account: DAOAccount?,
                                  with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLPromotionsBlkAPromotion?,
                                  then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadPromotions(for path: String,
                                  with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLPromotionsBlkAPromotion?,
                                  then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoReact(with reaction: DNSReactionType,
                         to promotion: DAOPromotion,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPromotionsBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUnreact(with reaction: DNSReactionType,
                           to promotion: DAOPromotion,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLPromotionsBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ promotion: DAOPromotion,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPromotionsBlkPromotion?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
