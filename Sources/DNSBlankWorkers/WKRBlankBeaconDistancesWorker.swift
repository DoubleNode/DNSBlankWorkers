//
//  WKRBlankBeaconDistancesWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSProtocols

open class WKRBlankBeaconDistancesWorker: WKRBlankBaseWorker, PTCLBeaconDistances_Protocol
{
    public var nextWorker: PTCLBeaconDistances_Protocol?

    public required init() {
        super.init()
    }
    public required init(nextWorker: PTCLBeaconDistances_Protocol) {
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

    open func doLoadBeaconDistances(with progress: PTCLProgressBlock?,
                                    and block: PTCLBeaconDistancesBlockVoidArrayDAOBeaconDistanceError?) throws {
        guard nextWorker != nil else { return }
        try nextWorker!.doLoadBeaconDistances(with: progress, and: block)
    }
}
