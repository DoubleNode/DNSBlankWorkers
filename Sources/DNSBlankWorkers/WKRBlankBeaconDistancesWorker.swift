//
//  WKRBlankBeaconDistancesWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSProtocols

open class WKRBlankBeaconDistancesWorker: WKRBlankBaseWorker, WKRPTCLBeaconDistances {
    public var callNextWhen: WKRPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLBeaconDistances?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLBeaconDistances,
                         for callNextWhen: WKRPTCLWorker.Call.NextWhen) {
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
    public func runDo(runNext: WKRPTCLCallBlock?,
                      doWork: WKRPTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Protocol Interface Methods
    public func doLoadBeaconDistances(with progress: WKRPTCLProgressBlock?,
                                      and block: WKRPTCLBeaconDistancesBlockArrayBeaconDistance?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadBeaconDistances(with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadBeaconDistances(with: progress, and: block, then: $0)
        })
    }

    // MARK: - Internal Work Methods
    open func intDoLoadBeaconDistances(with progress: WKRPTCLProgressBlock?,
                                       and block: WKRPTCLBeaconDistancesBlockArrayBeaconDistance?,
                                       then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
