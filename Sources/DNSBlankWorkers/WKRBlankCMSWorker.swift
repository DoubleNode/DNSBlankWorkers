//
//  WKRBlankCMSWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSProtocols

open class WKRBlankCMSWorker: WKRBlankBaseWorker, WKRPTCLCms {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLCms?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLCms,
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

    // MARK: - Worker Logic (Public) -
    public func doLoad(for group: String,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLCmsBlkAAny?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoad(for: group, with: progress, and: block)
        },
        doWork: {
            return self.intDoLoad(for: group, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoad(for group: String,
                       with block: WKRPTCLCmsBlkAAny?) {
        self.doLoad(for: group, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoad(for group: String,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLCmsBlkAAny?,
                        then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
