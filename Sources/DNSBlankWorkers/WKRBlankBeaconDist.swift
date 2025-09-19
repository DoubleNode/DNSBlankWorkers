//
//  WKRBlankBeaconDist.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSError
import DNSProtocols

open class WKRBlankBeaconDist: WKRBlankBase, WKRPTCLBeaconDist {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled

    public var nextWKRPTCLBeaconDist: WKRPTCLBeaconDist? {
        get { return nextWorker as? WKRPTCLBeaconDist }
        set { nextWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLBeaconDist,
                         for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.callNextWhen = callNextWhen
        self.nextWKRPTCLBeaconDist = nextWorker
    }

    override open func disableOption(_ option: String) {
        super.disableOption(option)
        nextWKRPTCLBeaconDist?.disableOption(option)
    }
    override open func enableOption(_ option: String) {
        super.enableOption(option)
        nextWKRPTCLBeaconDist?.enableOption(option)
    }
    @discardableResult
    public func runDo(runNext: DNSPTCLCallBlock?,
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWKRPTCLBeaconDist != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.BeaconDist.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadBeaconDistances(with progress: DNSPTCLProgressBlock?,
                                      and block: WKRPTCLBeaconDistBlkABeaconDistance?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLBeaconDist?.doLoadBeaconDistances(with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadBeaconDistances(with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadBeaconDistances(with block: WKRPTCLBeaconDistBlkABeaconDistance?) {
        self.doLoadBeaconDistances(with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadBeaconDistances(with progress: DNSPTCLProgressBlock?,
                                       and block: WKRPTCLBeaconDistBlkABeaconDistance?,
                                       then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
}
