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

open class WKRBlankCacheWorker: WKRBlankBaseWorker, PTCLCache
{
    public var callNextWhen: PTCLProtocol.Call.NextWhen = .whenUnhandled
    public var nextWorker: PTCLCache?
    public var systemsStateWorker: PTCLSystemsState? = WKRBlankSystemsStateWorker()

    public required init() {
        super.init()
    }
    public func register(nextWorker: PTCLCache,
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
    public func doDeleteObject(for id: String,
                               with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doDeleteObject(for: id, with: progress)
        },
        doWork: {
            return self.intDoDeleteObject(for: id, with: progress, then: $0)
        }) as! AnyPublisher<Bool, Error>
    }
    public func doLoadImage(from url: NSURL,
                            for id: String,
                            with progress: PTCLProgressBlock?) -> AnyPublisher<UIImage, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<UIImage, Error> { $0(.success(UIImage())) }.eraseToAnyPublisher()
            }
            return nextWorker.doLoadImage(from: url, for: id, with: progress)
        },
        doWork: {
            return self.intDoLoadImage(from: url, for: id, with: progress, then: $0)
        }) as! AnyPublisher<UIImage, Error>
    }
    public func doReadObject(for id: String,
                             with progress: PTCLProgressBlock?) -> AnyPublisher<Any, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Any, Error> { $0(.success(Data())) }.eraseToAnyPublisher()
            }
            return (AnyPublisher<Any, Error>)(nextWorker.doReadObject(for: id, with: progress))
        },
        doWork: {
            return (AnyPublisher<Any, Error>)(self.intDoReadObject(for: id, with: progress, then: $0))
        }) as! AnyPublisher<Any, Error>
    }
    public func doReadObject(for id: String,
                             with progress: PTCLProgressBlock?) -> AnyPublisher<String, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<String, Error> { $0(.success("")) }.eraseToAnyPublisher()
            }
            return (AnyPublisher<String, Error>)(nextWorker.doReadObject(for: id, with: progress))
        },
        doWork: {
            return (AnyPublisher<String, Error>)(self.intDoReadObject(for: id, with: progress, then: $0))
        }) as! AnyPublisher<String, Error>
    }
    public func doUpdate(object: Any,
                         for id: String,
                         with progress: PTCLProgressBlock?) -> AnyPublisher<Any, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Any, Error> { $0(.success(object)) }.eraseToAnyPublisher()
            }
            return nextWorker.doUpdate(object: object, for: id, with: progress)
        },
        doWork: {
            return self.intDoUpdate(object: object, for: id, with: progress, then: $0)
        }) as! AnyPublisher<Any, Error>
    }

    // MARK: - Internal Work Methods
    open func intDoDeleteObject(for id: String,
                                with progress: PTCLProgressBlock?,
                                then resultBlock: PTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
    open func intDoLoadImage(from url: NSURL,
                             for id: String,
                             with progress: PTCLProgressBlock?,
                             then resultBlock: PTCLResultBlock?) -> AnyPublisher<UIImage, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<UIImage, Error>
    }
    open func intDoReadObject(for id: String,
                              with progress: PTCLProgressBlock?,
                              then resultBlock: PTCLResultBlock?) -> AnyPublisher<Any, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Any, Error>
    }
    open func intDoReadObject(for id: String,
                              with progress: PTCLProgressBlock?,
                              then resultBlock: PTCLResultBlock?) -> AnyPublisher<String, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<String, Error>
    }
    open func intDoUpdate(object: Any,
                          for id: String,
                          with progress: PTCLProgressBlock?,
                          then resultBlock: PTCLResultBlock?) -> AnyPublisher<Any, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Any, Error>
    }
}
