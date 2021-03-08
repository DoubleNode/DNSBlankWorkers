//
//  WKRBlankCacheWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSProtocols
import UIKit

open class WKRBlankCacheWorker: WKRBlankBaseWorker, PTCLCache_Protocol
{
    public var nextWorker: PTCLCache_Protocol?

    public required init() {
        super.init()
    }

    public required init(nextWorker: PTCLCache_Protocol) {
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

    open func doDeleteObject(for id: String,
                             with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        guard let nextWorker = self.nextWorker else {
            return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
        }
        return nextWorker.doDeleteObject(for: id, with: progress)
    }
    open func doLoadImage(from url: NSURL,
                          for id: String,
                          with progress: PTCLProgressBlock?) -> AnyPublisher<UIImage, Error> {
        guard let nextWorker = self.nextWorker else {
            return Future<UIImage, Error> { $0(.success(UIImage())) }.eraseToAnyPublisher()
        }
        return nextWorker.doLoadImage(from: url, for: id, with: progress)
    }
    open func doReadObject(for id: String,
                           with progress: PTCLProgressBlock?) -> AnyPublisher<Any, Error> {
        guard let nextWorker = self.nextWorker else {
            return Future<Any, Error> { $0(.success(Data())) }.eraseToAnyPublisher()
        }
        return nextWorker.doReadObject(for: id, with: progress)
    }
    open func doReadObject(for id: String,
                           with progress: PTCLProgressBlock?) -> AnyPublisher<String, Error> {
        guard let nextWorker = self.nextWorker else {
            return Future<String, Error> { $0(.success("")) }.eraseToAnyPublisher()
        }
        return nextWorker.doReadObject(for: id, with: progress)
    }
    open func doUpdate(object: Any,
                       for id: String,
                       with progress: PTCLProgressBlock?) -> AnyPublisher<Any, Error> {
        guard let nextWorker = self.nextWorker else {
            return Future<Any, Error> { $0(.success(object)) }.eraseToAnyPublisher()
        }
        return nextWorker.doUpdate(object: object, for: id, with: progress)
    }
}
