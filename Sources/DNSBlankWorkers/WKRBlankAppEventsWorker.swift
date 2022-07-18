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
    public var callNextWhen: WKRPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAppEvents?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLAppEvents,
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
    public func doLoadAppEvents(with progress: WKRPTCLProgressBlock?,
                                and block: WKRPTCLAppEventsBlockArrayAppEvent?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoadAppEvents(with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoadAppEvents(with: progress, and: block, then: $0)
        })
    }

    // MARK: - Internal Work Methods
    open func intDoLoadAppEvents(with progress: WKRPTCLProgressBlock?,
                                 and block: WKRPTCLAppEventsBlockArrayAppEvent?,
                                 then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
