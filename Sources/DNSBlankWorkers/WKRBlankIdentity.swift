//
//  WKRBlankIdentity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSError
import DNSProtocols

open class WKRBlankIdentity: WKRBlankBase, WKRPTCLIdentity {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled

    public var nextWKRPTCLIdentity: WKRPTCLIdentity? {
        get { return nextWorker as? WKRPTCLIdentity }
        set { nextWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLIdentity,
                         for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.callNextWhen = callNextWhen
        self.nextWKRPTCLIdentity = nextWorker
    }

    override open func disableOption(_ option: String) {
        super.disableOption(option)
        nextWKRPTCLIdentity?.disableOption(option)
    }
    override open func enableOption(_ option: String) {
        super.enableOption(option)
        nextWKRPTCLIdentity?.enableOption(option)
    }
    @discardableResult
    public func runDo(runNext: DNSPTCLCallBlock?,
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWKRPTCLIdentity != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    @discardableResult
    public func runDoPub(runNext: DNSPTCLCallBlock?,
                         doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Identity.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doClearIdentity(with progress: DNSPTCLProgressBlock?) -> WKRPTCLIdentityPubVoid {
        return self.runDoPub(runNext: {
            guard self.nextWorker != nil else {
                return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return self.nextWKRPTCLIdentity?.doClearIdentity(with: progress)
        },
                             doWork: {
            return self.intDoClearIdentity(with: progress, then: $0)
        }) as! WKRPTCLIdentityPubVoid // swiftlint:disable:this force_cast
    }
    public func doJoin(group: String,
                       with progress: DNSPTCLProgressBlock?) -> WKRPTCLIdentityPubVoid {
        return self.runDoPub(runNext: {
            guard self.nextWorker != nil else {
                return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return self.nextWKRPTCLIdentity?.doJoin(group: group, with: progress)
        },
                             doWork: {
            return self.intDoJoin(group: group, with: progress, then: $0)
        }) as! WKRPTCLIdentityPubVoid // swiftlint:disable:this force_cast
    }
    public func doLeave(group: String,
                        with progress: DNSPTCLProgressBlock?) -> WKRPTCLIdentityPubVoid {
        return self.runDoPub(runNext: {
            guard self.nextWorker != nil else {
                return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return self.nextWKRPTCLIdentity?.doLeave(group: group, with: progress)
        },
                             doWork: {
            return self.intDoLeave(group: group, with: progress, then: $0)
        }) as! WKRPTCLIdentityPubVoid // swiftlint:disable:this force_cast
    }
    public func doSetIdentity(using data: DNSDataDictionary,
                              with progress: DNSPTCLProgressBlock?) -> WKRPTCLIdentityPubVoid {
        return self.runDoPub(runNext: {
            guard self.nextWorker != nil else {
                return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return self.nextWKRPTCLIdentity?.doSetIdentity(using: data, with: progress)
        },
                             doWork: {
            return self.intDoSetIdentity(using: data, with: progress, then: $0)
        }) as! WKRPTCLIdentityPubVoid // swiftlint:disable:this force_cast
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doClearIdentity() -> WKRPTCLIdentityPubVoid {
        return self.doClearIdentity(with: nil)
    }
    public func doJoin(group: String) -> WKRPTCLIdentityPubVoid {
        return self.doJoin(group: group, with: nil)
    }
    public func doLeave(group: String) -> WKRPTCLIdentityPubVoid {
        return self.doLeave(group: group, with: nil)
    }
    public func doSetIdentity(using data: DNSDataDictionary) -> WKRPTCLIdentityPubVoid {
        return self.doSetIdentity(using: data, with: nil)
    }

    // MARK: - Internal Work Methods
    open func intDoClearIdentity(with progress: DNSPTCLProgressBlock?,
                                 then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLIdentityPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
    }
    open func intDoJoin(group: String,
                        with progress: DNSPTCLProgressBlock?,
                        then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLIdentityPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
    }
    open func intDoLeave(group: String,
                         with progress: DNSPTCLProgressBlock?,
                         then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLIdentityPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
    }
    open func intDoSetIdentity(using data: DNSDataDictionary,
                               with progress: DNSPTCLProgressBlock?,
                               then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLIdentityPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
   }
}
