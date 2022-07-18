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

open class WKRBlankCacheWorker: WKRBlankBaseWorker, WKRPTCLCache {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLCache?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLCache,
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
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doDeleteObject(for id: String,
                               with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
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
                            with progress: DNSPTCLProgressBlock?) -> AnyPublisher<UIImage, Error> {
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
                             with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Any, Error> {
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
                             with progress: DNSPTCLProgressBlock?) -> AnyPublisher<String, Error> {
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
                         with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Any, Error> {
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

    // MARK: - Worker Logic (Shortcuts) -
    public func doDeleteObject(for id: String) -> AnyPublisher<Bool, Error> {
        return self.doDeleteObject(for: id, with: nil)
    }
    public func doLoadImage(from url: NSURL,
                            for id: String) -> AnyPublisher<UIImage, Error> {
        return self.doLoadImage(from: url, for: id, with: nil)
    }
    public func doReadObject(for id: String) -> AnyPublisher<Any, Error> {
        return (AnyPublisher<Any, Error>)(self.doReadObject(for: id, with: nil))
    }
    public func doReadObject(for id: String) -> AnyPublisher<String, Error> {
        return (AnyPublisher<String, Error>)(self.doReadObject(for: id, with: nil))
    }
    public func doUpdate(object: Any,
                         for id: String) -> AnyPublisher<Any, Error> {
        return self.doUpdate(object: object, for: id, with: nil)
    }

    // MARK: - Internal Work Methods
    open func intDoDeleteObject(for id: String,
                                with progress: DNSPTCLProgressBlock?,
                                then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
    open func intDoLoadImage(from url: NSURL,
                             for id: String,
                             with progress: DNSPTCLProgressBlock?,
                             then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<UIImage, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<UIImage, Error>
    }
    open func intDoReadObject(for id: String,
                              with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<Any, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Any, Error>
    }
    open func intDoReadObject(for id: String,
                              with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<String, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<String, Error>
    }
    open func intDoUpdate(object: Any,
                          for id: String,
                          with progress: DNSPTCLProgressBlock?,
                          then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<Any, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Any, Error>
    }
}
