//
//  WKRBlankAppEventsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankAppEventsWorker: WKRBlankBaseWorker, WKRPTCLAppEvents {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAppEvents?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLAppEvents,
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
    public func doLoadAppEvents(with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLAppEventsBlkAAppEvent?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doLoadAppEvents(with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadAppEvents(with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadAppEvents(with block: WKRPTCLAppEventsBlkAAppEvent?) throws {
        try self.doLoadAppEvents(with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadAppEvents(with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLAppEventsBlkAAppEvent?,
                                 then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
