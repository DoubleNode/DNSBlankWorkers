//
//  WKRBlankProductsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSProtocols
import Foundation

open class WKRBlankProductsWorker: WKRBlankBaseWorker, WKRPTCLProducts {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLProducts?

    public required init() {
        super.init()
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
                      doWork: DNSPTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadProduct(for id: String,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLProductsBlkProduct?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadProduct(for: id, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadProduct(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadProducts(with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLProductsBlkAProduct?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadProducts(with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadProducts(with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ product: DAOProduct,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLProductsBlkVoid?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doRemove(product, with: progress, and: block)
        },
        doWork: {
            return try self.intDoRemove(product, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ product: DAOProduct,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLProductsBlkVoid?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doUpdate(product, with: progress, and: block)
        },
        doWork: {
            return try self.intDoUpdate(product, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadProduct(for id: String,
                              with block: WKRPTCLProductsBlkProduct?) throws {
        try self.doLoadProduct(for: id, with: nil, and: block)
    }
    public func doLoadProducts(with block: WKRPTCLProductsBlkAProduct?) throws {
        try self.doLoadProducts(with: nil, and: block)
    }
    public func doRemove(_ product: DAOProduct,
                         with block: WKRPTCLProductsBlkVoid?) throws {
        try self.doRemove(product, with: nil, and: block)
    }
    public func doUpdate(_ product: DAOProduct,
                         with block: WKRPTCLProductsBlkVoid?) throws {
        try self.doUpdate(product, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadProduct(for id: String,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLProductsBlkProduct?,
                               then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadProducts(with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLProductsBlkAProduct?,
                                then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemove(_ product: DAOProduct,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLProductsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ product: DAOProduct,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLProductsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
