//
//  WKRBlankBeaconsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSProtocols
import Foundation

open class WKRBlankBeaconsWorker: WKRBlankBaseWorker, PTCLBeacons_Protocol
{
    public var nextWorker: PTCLBeacons_Protocol?

    public required init() {
        super.init()
    }

    public required init(nextWorker: PTCLBeacons_Protocol) {
        super.init()
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

    // MARK: - Business Logic / Single Item CRUD

    open func doLoadBeacons(in center: DAOCenter,
                            with progress: PTCLProgressBlock?,
                            and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doLoadBeacons(in: center, with: progress, and: block)
    }
    open func doLoadBeacons(in center: DAOCenter,
                            for activity: DAOActivity,
                            with progress: PTCLProgressBlock?,
                            and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doLoadBeacons(in: center, for: activity, with: progress, and: block)
    }
    open func doRangeBeacons(named uuids: [UUID],
                             for processKey: String,
                             with progress: PTCLProgressBlock?,
                             and block: PTCLBeaconsBlockVoidArrayDAOBeaconError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doRangeBeacons(named: uuids, for: processKey, with: progress, and: block)
    }
    open func doStopRangeBeacons(for processKey: String) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doStopRangeBeacons(for: processKey)
    }
}
