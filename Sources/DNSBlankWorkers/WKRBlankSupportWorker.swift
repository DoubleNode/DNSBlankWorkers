//
//  WKRBlankSupportWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSProtocols

open class WKRBlankSupportWorker: WKRBlankBaseWorker, PTCLSupport_Protocol
{
    public var nextWorker: PTCLSupport_Protocol?

    public required init() {
        super.init()
    }
    public required init(nextWorker: PTCLSupport_Protocol) {
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

    open func doGetUpdatedCount(with progress: PTCLProgressBlock?) -> AnyPublisher<Int, Error> {
        guard let nextWorker = self.nextWorker else {
            return Future<Int, Error> { $0(.success(0)) }.eraseToAnyPublisher()
        }
        return nextWorker.doGetUpdatedCount(with: progress)
    }
}
