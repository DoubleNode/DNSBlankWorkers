//
//  WKRBlankCache.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSError
import DNSProtocols
import UIKit

open class WKRBlankCache: WKRBlankBase, WKRPTCLCache {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLCache?

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
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
                      doWork: DNSPTCLCallResultBlock = { return $0?(.unhandled) }) -> Any? {
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    @discardableResult
    public func runDoPub(runNext: DNSPTCLCallBlock?,
                         doWork: DNSPTCLCallResultBlock = { return $0?(.unhandled) }) -> Any? {
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Cache.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doDeleteObject(for id: String,
                               with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubVoid {
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLCacheFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return nextWorker.doDeleteObject(for: id, with: progress)
        },
                             doWork: {
            return self.intDoDeleteObject(for: id, with: progress, then: $0)
        }) as! WKRPTCLCachePubVoid
    }
    public func doLoadImage(from url: NSURL,
                            for id: String,
                            with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubImage {
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLCacheFutImage { $0(.success(UIImage())) }.eraseToAnyPublisher()
            }
            return nextWorker.doLoadImage(from: url, for: id, with: progress)
        },
                             doWork: {
            return self.intDoLoadImage(from: url, for: id, with: progress, then: $0)
        }) as! WKRPTCLCachePubImage
    }
    public func doReadObject(for id: String,
                             with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubAny {
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLCacheFutAny { $0(.success(Data())) }.eraseToAnyPublisher()
            }
            return nextWorker.doReadObject(for: id, with: progress)
        },
                             doWork: {
            return self.intDoReadObject(for: id, with: progress, then: $0)
        }) as! WKRPTCLCachePubAny
    }
    public func doReadString(for id: String,
                             with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubString {
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLCacheFutString { $0(.success("")) }.eraseToAnyPublisher()
            }
            return nextWorker.doReadString(for: id, with: progress)
        },
                             doWork: {
            return self.intDoReadString(for: id, with: progress, then: $0)
        }) as! WKRPTCLCachePubString
    }
    public func doUpdate(object: Any,
                         for id: String,
                         with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubAny {
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLCacheFutAny { $0(.success(object)) }.eraseToAnyPublisher()
            }
            return nextWorker.doUpdate(object: object, for: id, with: progress)
        },
                             doWork: {
            return self.intDoUpdate(object: object, for: id, with: progress, then: $0)
        }) as! WKRPTCLCachePubAny
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doDeleteObject(for id: String) -> WKRPTCLCachePubVoid {
        return self.doDeleteObject(for: id, with: nil)
    }
    public func doLoadImage(from url: NSURL,
                            for id: String) -> WKRPTCLCachePubImage {
        return self.doLoadImage(from: url, for: id, with: nil)
    }
    public func doReadObject(for id: String) -> WKRPTCLCachePubAny {
        return self.doReadObject(for: id, with: nil)
    }
    public func doReadString(for id: String) -> WKRPTCLCachePubString {
        return self.doReadString(for: id, with: nil)
    }
    public func doUpdate(object: Any,
                         for id: String) -> WKRPTCLCachePubAny {
        return self.doUpdate(object: object, for: id, with: nil)
    }

    // MARK: - Internal Work Methods
    open func intDoDeleteObject(for id: String,
                                with progress: DNSPTCLProgressBlock?,
                                then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLCachePubVoid {
        return resultBlock?(.unhandled) as! WKRPTCLCachePubVoid
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
    open func intDoReadString(for id: String,
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
