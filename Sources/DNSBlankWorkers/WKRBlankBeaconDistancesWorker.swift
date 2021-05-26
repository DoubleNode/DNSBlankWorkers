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
    public var callNextWhen: PTCLCallNextWhen = .whenUnhandled
    public var nextWorker: PTCLBeaconDistances_Protocol?

    public required init() {
        super.init()
    }
    public required init(call callNextWhen: PTCLCallNextWhen,
                         nextWorker: PTCLBeaconDistances_Protocol) {
        super.init()
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
    public func runDo(runNext: PTCLCallBlock?,
                      doWork: PTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Business Logic / Single Item CRUD

    open func doLoadBeaconDistances(with progress: PTCLProgressBlock?,
                                    and block: PTCLBeaconDistancesBlockVoidArrayDAOBeaconDistanceError?) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadBeaconDistances(with: progress, and: block)
        }
    }
}
