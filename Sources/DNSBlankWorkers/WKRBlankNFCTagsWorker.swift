//
//  WKRBlankNFCTagsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankNFCTagsWorker: WKRBlankBaseWorker, PTCLNFCTags_Protocol
{
    public var nextWorker: PTCLNFCTags_Protocol?

    public required init() {
        super.init()
    }

    public required init(nextWorker: PTCLNFCTags_Protocol) {
        super.init()
        self.nextWorker = nextWorker
    }

    override open func enableOption(option: String) {
        nextWorker?.enableOption(option: option)
    }

    override open func disableOption(option: String) {
        nextWorker?.disableOption(option: option)
    }

    // MARK: - Business Logic / Single Item CRUD

    open func doScanTags(for key: String,
                         with progress: PTCLProgressBlock?,
                         and block: PTCLNFCTagsBlockVoidArrayNFCNDEFMessageDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doScanTags(for: key, with: progress, and:block)
    }
}
