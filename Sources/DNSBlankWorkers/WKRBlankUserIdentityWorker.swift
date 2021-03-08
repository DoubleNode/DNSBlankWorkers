//
//  WKRBlankUserIdentityWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSProtocols

open class WKRBlankUserIdentityWorker: WKRBlankBaseWorker, PTCLUserIdentity_Protocol
{
    public var nextWorker: PTCLUserIdentity_Protocol?

    public required init() {
        super.init()
    }
    public required init(nextWorker: PTCLUserIdentity_Protocol) {
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

    open func doClearIdentity(with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        guard let nextWorker = self.nextWorker else {
            return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
        }
        return nextWorker.doClearIdentity(with: progress)
    }
    open func doJoin(group: String,
                     with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        guard let nextWorker = self.nextWorker else {
            return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
        }
        return nextWorker.doJoin(group: group, with: progress)
    }
    open func doLeave(group: String,
                      with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        guard let nextWorker = self.nextWorker else {
            return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
        }
        return nextWorker.doLeave(group: group, with: progress)
    }
    open func doSetIdentity(using data: [String: Any?],
                            with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        guard let nextWorker = self.nextWorker else {
            return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
        }
        return nextWorker.doSetIdentity(using: data, with: progress)
   }
}
