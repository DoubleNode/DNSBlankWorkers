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
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    @discardableResult
    public func runDoPub(runNext: DNSPTCLCallBlock?,
                         doWork: DNSPTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doDeleteObject(for id: String,
                               with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubBool {
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<WKRPTCLCacheRtnBool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doDeleteObject(for: id, with: progress)
        },
                                  doWork: {
            return self.intDoDeleteObject(for: id, with: progress, then: $0)
        }) as! WKRPTCLCachePubBool
    }
    public func doLoadImage(from url: NSURL,
                            for id: String,
                            with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubImage {
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<WKRPTCLCacheRtnImage, Error> { $0(.success(UIImage())) }.eraseToAnyPublisher()
            }
            return nextWorker.doLoadImage(from: url, for: id, with: progress)
        },
                                  doWork: {
            return self.intDoLoadImage(from: url, for: id, with: progress, then: $0)
        }) as! WKRPTCLCachePubImage
    }
    public func doReadObject(for id: String,
                             with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubAny {
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<WKRPTCLCacheRtnAny, Error> { $0(.success(Data())) }.eraseToAnyPublisher()
            }
            return (WKRPTCLCachePubAny)(nextWorker.doReadObject(for: id, with: progress))
        },
                                  doWork: {
            return (WKRPTCLCachePubAny)(self.intDoReadObject(for: id, with: progress, then: $0))
        }) as! WKRPTCLCachePubAny
    }
    public func doReadObject(for id: String,
                             with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubString {
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<WKRPTCLCacheRtnString, Error> { $0(.success("")) }.eraseToAnyPublisher()
            }
            return (WKRPTCLCachePubString)(nextWorker.doReadObject(for: id, with: progress))
        },
                                  doWork: {
            return (WKRPTCLCachePubString)(self.intDoReadObject(for: id, with: progress, then: $0))
        }) as! WKRPTCLCachePubString
    }
    public func doUpdate(object: Any,
                         for id: String,
                         with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubAny {
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<WKRPTCLCacheRtnAny, Error> { $0(.success(object)) }.eraseToAnyPublisher()
            }
            return nextWorker.doUpdate(object: object, for: id, with: progress)
        },
                                  doWork: {
            return self.intDoUpdate(object: object, for: id, with: progress, then: $0)
        }) as! WKRPTCLCachePubAny
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doDeleteObject(for id: String) -> WKRPTCLCachePubBool {
        return self.doDeleteObject(for: id, with: nil)
    }
    public func doLoadImage(from url: NSURL,
                            for id: String) -> WKRPTCLCachePubImage {
        return self.doLoadImage(from: url, for: id, with: nil)
    }
    public func doReadObject(for id: String) -> WKRPTCLCachePubAny {
        return (AnyPublisher<Any, Error>)(self.doReadObject(for: id, with: nil))
    }
    public func doReadObject(for id: String) -> WKRPTCLCachePubString {
        return (AnyPublisher<String, Error>)(self.doReadObject(for: id, with: nil))
    }
    public func doUpdate(object: Any,
                         for id: String) -> WKRPTCLCachePubAny {
        return self.doUpdate(object: object, for: id, with: nil)
    }

    // MARK: - Internal Work Methods
    open func intDoDeleteObject(for id: String,
                                with progress: DNSPTCLProgressBlock?,
                                then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubBool {
        return resultBlock?(.unhandled) as! WKRPTCLCachePubBool
    }
    open func intDoLoadImage(from url: NSURL,
                             for id: String,
                             with progress: DNSPTCLProgressBlock?,
                             then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubImage {
        return resultBlock?(.unhandled) as! WKRPTCLCachePubImage
    }
    open func intDoReadObject(for id: String,
                              with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubAny {
        return resultBlock?(.unhandled) as! WKRPTCLCachePubAny
    }
    open func intDoReadObject(for id: String,
                              with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubString {
        return resultBlock?(.unhandled) as! WKRPTCLCachePubString
    }
    open func intDoUpdate(object: Any,
                          for id: String,
                          with progress: DNSPTCLProgressBlock?,
                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubAny {
        return resultBlock?(.unhandled) as! WKRPTCLCachePubAny
    }
}
