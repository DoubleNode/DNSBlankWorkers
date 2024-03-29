//
//  WKRBlankProducts.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankProducts: WKRBlankBase, WKRPTCLProducts {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLProducts?

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLProducts,
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
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Products.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Base Worker Logic -
    open func doAnalytics(for object: DAOProduct,
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
    public func doLoadPricing(for product: DAOProduct,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLProductsBlkPricing?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadPricing(for: product, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadPricing(for: product, with: progress, and: block, then: $0)
        })
    }
    public func doLoadProduct(for id: String,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLProductsBlkProduct?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadProduct(for: id, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadProduct(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadProduct(for id: String,
                              and place: DAOPlace,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLProductsBlkProduct?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadProduct(for: id, and: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadProduct(for: id, and: place, with: progress, and: block, then: $0)
        })
    }
    public func doLoadProducts(with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLProductsBlkAProduct?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadProducts(with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadProducts(with: progress, and: block, then: $0)
        })
    }
    public func doLoadProducts(for place: DAOPlace,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLProductsBlkAProduct?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadProducts(for: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadProducts(for: place, with: progress, and: block, then: $0)
        })
    }
    public func doReact(with reaction: DNSReactionType,
                        to product: DAOProduct,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLProductsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doReact(with: reaction, to: product, with: progress, and: block)
        },
                   doWork: {
            return self.intDoReact(with: reaction, to: product, with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ product: DAOProduct,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLProductsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRemove(product, with: progress, and: block)
        },
                   doWork: {
            return self.intDoRemove(product, with: progress, and: block, then: $0)
        })
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to product: DAOProduct,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLProductsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUnreact(with: reaction, to: product, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUnreact(with: reaction, to: product, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ pricing: DAOPricing,
                         for product: DAOProduct,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLProductsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(pricing, for: product, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(pricing, for: product, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ product: DAOProduct,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLProductsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(product, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(product, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadPricing(for product: DAOProduct,
                              with block: WKRPTCLProductsBlkPricing?) {
        self.doLoadPricing(for: product, with: nil, and: block)
    }
    public func doLoadProduct(for id: String,
                              with block: WKRPTCLProductsBlkProduct?) {
        self.doLoadProduct(for: id, with: nil, and: block)
    }
    public func doLoadProduct(for id: String,
                              and place: DAOPlace,
                              with block: WKRPTCLProductsBlkProduct?) {
        self.doLoadProduct(for: id, and: place, with: nil, and: block)
    }
    public func doLoadProducts(with block: WKRPTCLProductsBlkAProduct?) {
        self.doLoadProducts(with: nil, and: block)
    }
    public func doLoadProducts(for place: DAOPlace,
                               with block: WKRPTCLProductsBlkAProduct?) {
        self.doLoadProducts(for: place, with: nil, and: block)
    }
    public func doReact(with reaction: DNSReactionType,
                        to product: DAOProduct,
                        with block: WKRPTCLProductsBlkMeta?) {
        self.doReact(with: reaction, to: product, with: nil, and: block)
    }
    public func doRemove(_ product: DAOProduct,
                         with block: WKRPTCLProductsBlkVoid?) {
        self.doRemove(product, with: nil, and: block)
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to product: DAOProduct,
                          with block: WKRPTCLProductsBlkMeta?) {
        self.doUnreact(with: reaction, to: product, with: nil, and: block)
    }
    public func doUpdate(_ pricing: DAOPricing,
                         for product: DAOProduct,
                         with block: WKRPTCLProductsBlkVoid?) {
        self.doUpdate(pricing, for: product, with: nil, and: block)
    }
    public func doUpdate(_ product: DAOProduct,
                         with block: WKRPTCLProductsBlkVoid?) {
        self.doUpdate(product, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadPricing(for product: DAOProduct,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLProductsBlkPricing?,
                               then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadProduct(for id: String,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLProductsBlkProduct?,
                               then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadProduct(for id: String,
                               and place: DAOPlace,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLProductsBlkProduct?,
                               then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadProducts(with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLProductsBlkAProduct?,
                                then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadProducts(for place: DAOPlace,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLProductsBlkAProduct?,
                                then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoReact(with reaction: DNSReactionType,
                         to product: DAOProduct,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLProductsBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemove(_ product: DAOProduct,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLProductsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUnreact(with reaction: DNSReactionType,
                           to product: DAOProduct,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLProductsBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ pricing: DAOPricing,
                          for product: DAOProduct,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLProductsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ product: DAOProduct,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLProductsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
