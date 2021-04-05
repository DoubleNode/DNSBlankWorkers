//
//  WKRBlankCMSWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSProtocols

open class WKRBlankCMSWorker: WKRBlankBaseWorker, PTCLCMS_Protocol
{
    public var nextWorker: PTCLCMS_Protocol?

    public required init() {
        super.init()
    }
    public required init(nextWorker: PTCLCMS_Protocol) {
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

    open func doLoad(for group: String,
                     with progress: PTCLProgressBlock?,
                     and block: PTCLCMSBlockVoidArrayDNSError?) throws {
        guard nextWorker != nil else {
            return
        }
        try nextWorker!.doLoad(for: group, with: progress, and: block)
    }
}
