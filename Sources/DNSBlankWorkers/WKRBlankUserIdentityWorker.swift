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

open class WKRBlankUserIdentityWorker: WKRBlankBaseWorker, WKRPTCLUserIdentity {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLUserIdentity?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLUserIdentity,
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
    public func doClearIdentity(with progress: DNSPTCLProgressBlock?) -> WKRPTCLUserIdentityPubBool {
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<WKRPTCLUserIdentityRtnBool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doClearIdentity(with: progress)
        },
                                  doWork: {
            return self.intDoClearIdentity(with: progress, then: $0)
        }) as! WKRPTCLUserIdentityPubBool
    }
    public func doJoin(group: String,
                       with progress: DNSPTCLProgressBlock?) -> WKRPTCLUserIdentityPubBool {
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<WKRPTCLUserIdentityRtnBool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doJoin(group: group, with: progress)
        },
                                  doWork: {
            return self.intDoJoin(group: group, with: progress, then: $0)
        }) as! WKRPTCLUserIdentityPubBool
    }
    public func doLeave(group: String,
                        with progress: DNSPTCLProgressBlock?) -> WKRPTCLUserIdentityPubBool {
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<WKRPTCLUserIdentityRtnBool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doLeave(group: group, with: progress)
        },
                                  doWork: {
            return self.intDoLeave(group: group, with: progress, then: $0)
        }) as! WKRPTCLUserIdentityPubBool
    }
    public func doSetIdentity(using data: [String: Any?],
                              with progress: DNSPTCLProgressBlock?) -> WKRPTCLUserIdentityPubBool {
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<WKRPTCLUserIdentityRtnBool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doSetIdentity(using: data, with: progress)
        },
                                  doWork: {
            return self.intDoSetIdentity(using: data, with: progress, then: $0)
        }) as! WKRPTCLUserIdentityPubBool
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doClearIdentity() -> WKRPTCLUserIdentityPubBool {
        return self.doClearIdentity(with: nil)
    }
    public func doJoin(group: String) -> WKRPTCLUserIdentityPubBool {
        return self.doJoin(group: group, with: nil)
    }
    public func doLeave(group: String) -> WKRPTCLUserIdentityPubBool {
        return self.doLeave(group: group, with: nil)
    }
    public func doSetIdentity(using data: [String: Any?]) -> WKRPTCLUserIdentityPubBool {
        return self.doSetIdentity(using: data, with: nil)
    }

    // MARK: - Internal Work Methods
    open func intDoClearIdentity(with progress: DNSPTCLProgressBlock?,
                                 then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLUserIdentityPubBool {
        return resultBlock?(.unhandled) as! WKRPTCLUserIdentityPubBool
    }
    open func intDoJoin(group: String,
                        with progress: DNSPTCLProgressBlock?,
                        then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLUserIdentityPubBool {
        return resultBlock?(.unhandled) as! WKRPTCLUserIdentityPubBool
    }
    open func intDoLeave(group: String,
                         with progress: DNSPTCLProgressBlock?,
                         then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLUserIdentityPubBool {
        return resultBlock?(.unhandled) as! WKRPTCLUserIdentityPubBool
    }
    open func intDoSetIdentity(using data: [String: Any?],
                               with progress: DNSPTCLProgressBlock?,
                               then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLUserIdentityPubBool {
        return resultBlock?(.unhandled) as! WKRPTCLUserIdentityPubBool
   }
}
