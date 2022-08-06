//
//  WKRBlankBeaconsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankBeaconsWorker: WKRBlankBaseWorker, WKRPTCLBeacons {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLBeacons?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLBeacons,
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
        if case DNSError.Beacons.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadBeacons(in place: DAOPlace,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLBeaconsBlkABeacon?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadBeacons(in: place, with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadBeacons(in: place, with: progress, and: block, then: $0)
        })
    }
    public func doLoadBeacons(in place: DAOPlace,
                              for activity: DAOActivity,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLBeaconsBlkABeacon?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadBeacons(in: place, for: activity,
                                                  with: progress, and: block)
        },
        doWork: {
            return self.intDoLoadBeacons(in: place, for: activity,
                                         with: progress, and: block, then: $0)
        })
    }
    public func doRangeBeacons(named uuids: [UUID],
                               for processKey: String,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLBeaconsBlkABeacon?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRangeBeacons(named: uuids, for: processKey,
                                                   with: progress, and: block)
        },
        doWork: {
            return self.intDoRangeBeacons(named: uuids, for: processKey,
                                          with: progress, and: block, then: $0)
        })
    }
    public func doStopRangeBeacons(for processKey: String) -> WKRPTCLBeaconsResVoid {
        return self.runDo(runNext: {
            return self.nextWorker?.doStopRangeBeacons(for: processKey)
        },
        doWork: {
            return self.intDoStopRangeBeacons(for: processKey, then: $0)
        }) as! WKRPTCLBeaconsResVoid // swiftlint:disable:this force_cast
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadBeacons(in place: DAOPlace,
                              with block: WKRPTCLBeaconsBlkABeacon?) {
        self.doLoadBeacons(in: place, with: nil, and: block)
    }
    public func doLoadBeacons(in place: DAOPlace,
                              for activity: DAOActivity,
                              with block: WKRPTCLBeaconsBlkABeacon?) {
        self.doLoadBeacons(in: place, for: activity, with: nil, and: block)
    }
    public func doRangeBeacons(named uuids: [UUID],
                               for processKey: String,
                               with block: WKRPTCLBeaconsBlkABeacon?) {
        self.doRangeBeacons(named: uuids, for: processKey, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadBeacons(in place: DAOPlace,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLBeaconsBlkABeacon?,
                               then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadBeacons(in place: DAOPlace,
                               for activity: DAOActivity,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLBeaconsBlkABeacon?,
                               then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRangeBeacons(named uuids: [UUID],
                                for processKey: String,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLBeaconsBlkABeacon?,
                                then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoStopRangeBeacons(for processKey: String,
                                    then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLBeaconsResVoid {
        _ = resultBlock?(.unhandled)
        return .success
    }
}
