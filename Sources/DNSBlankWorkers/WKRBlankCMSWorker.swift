//
//  WKRBlankCMSWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSProtocols

open class WKRBlankCMSWorker: WKRBlankBaseWorker, PTCLCms
{
    public var callNextWhen: PTCLProtocol.Call.NextWhen = .whenUnhandled
    public var nextWorker: PTCLCms?

    public required init() {
        super.init()
    }
    public func register(nextWorker: PTCLCms,
                         for callNextWhen: PTCLProtocol.Call.NextWhen) {
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

    // MARK: - Protocol Interface Methods
    public func doLoad(for group: String,
                       with progress: PTCLProgressBlock?,
                       and block: PTCLCmsBlockVoidArrayAny?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doLoad(for: group, with: progress, and: block)
        },
        doWork: {
            return try self.intDoLoad(for: group, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Internal Work Methods
    open func intDoLoad(for group: String,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLCmsBlockVoidArrayAny?,
                        then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
