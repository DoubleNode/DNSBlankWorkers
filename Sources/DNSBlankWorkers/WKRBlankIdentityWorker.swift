//
//  WKRBlankIdentityWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSProtocols

open class WKRBlankIdentityWorker: WKRBlankBaseWorker, WKRPTCLIdentity {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLIdentity?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLIdentity,
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

    // MARK: - Worker Logic (Public) -
    public func doClearIdentity(with progress: DNSPTCLProgressBlock?) -> WKRPTCLIdentityPubVoid {
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return nextWorker.doClearIdentity(with: progress)
        },
                                  doWork: {
            return self.intDoClearIdentity(with: progress, then: $0)
        }) as! WKRPTCLIdentityPubVoid // swiftlint:disable:this force_cast
    }
    public func doJoin(group: String,
                       with progress: DNSPTCLProgressBlock?) -> WKRPTCLIdentityPubVoid {
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return nextWorker.doJoin(group: group, with: progress)
        },
                                  doWork: {
            return self.intDoJoin(group: group, with: progress, then: $0)
        }) as! WKRPTCLIdentityPubVoid // swiftlint:disable:this force_cast
    }
    public func doLeave(group: String,
                        with progress: DNSPTCLProgressBlock?) -> WKRPTCLIdentityPubVoid {
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return nextWorker.doLeave(group: group, with: progress)
        },
                                  doWork: {
            return self.intDoLeave(group: group, with: progress, then: $0)
        }) as! WKRPTCLIdentityPubVoid // swiftlint:disable:this force_cast
    }
    public func doSetIdentity(using data: DNSDataDictionary,
                              with progress: DNSPTCLProgressBlock?) -> WKRPTCLIdentityPubVoid {
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLIdentityFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return nextWorker.doSetIdentity(using: data, with: progress)
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
        return resultBlock?(.unhandled) as! WKRPTCLIdentityPubVoid // swiftlint:disable:this force_cast
    }
    open func intDoJoin(group: String,
                        with progress: DNSPTCLProgressBlock?,
                        then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLIdentityPubVoid {
        return resultBlock?(.unhandled) as! WKRPTCLIdentityPubVoid // swiftlint:disable:this force_cast
    }
    open func intDoLeave(group: String,
                         with progress: DNSPTCLProgressBlock?,
                         then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLIdentityPubVoid {
        return resultBlock?(.unhandled) as! WKRPTCLIdentityPubVoid // swiftlint:disable:this force_cast
    }
    open func intDoSetIdentity(using data: DNSDataDictionary,
                               with progress: DNSPTCLProgressBlock?,
                               then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLIdentityPubVoid {
        return resultBlock?(.unhandled) as! WKRPTCLIdentityPubVoid // swiftlint:disable:this force_cast
   }
}
