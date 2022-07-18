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
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLBeaconDistances?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLBeaconDistances,
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
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadBeaconDistances(with progress: DNSPTCLProgressBlock?,
                                      and block: WKRPTCLBeaconDistancesBlockArrayBeaconDistance?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadBeaconDistances(with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadBeaconDistances(with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadBeaconDistances(with block: WKRPTCLBeaconDistancesBlockArrayBeaconDistance?) throws {
        try self.doLoadBeaconDistances(with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadBeaconDistances(with progress: DNSPTCLProgressBlock?,
                                       and block: WKRPTCLBeaconDistancesBlockArrayBeaconDistance?,
                                       then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
