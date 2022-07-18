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
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doClearIdentity(with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doClearIdentity(with: progress)
        },
        doWork: {
            return self.intDoClearIdentity(with: progress, then: $0)
        }) as! AnyPublisher<Bool, Error>
    }
    public func doJoin(group: String,
                       with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doJoin(group: group, with: progress)
        },
        doWork: {
            return self.intDoJoin(group: group, with: progress, then: $0)
        }) as! AnyPublisher<Bool, Error>
    }
    public func doLeave(group: String,
                        with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doLeave(group: group, with: progress)
        },
        doWork: {
            return self.intDoLeave(group: group, with: progress, then: $0)
        }) as! AnyPublisher<Bool, Error>
    }
    public func doSetIdentity(using data: [String: Any?],
                              with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doSetIdentity(using: data, with: progress)
        },
        doWork: {
            return self.intDoSetIdentity(using: data, with: progress, then: $0)
        }) as! AnyPublisher<Bool, Error>
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doClearIdentity() -> AnyPublisher<Bool, Error> {
        return self.doClearIdentity(with: nil)
    }
    public func doJoin(group: String) -> AnyPublisher<Bool, Error> {
        return self.doJoin(group: group, with: nil)
    }
    public func doLeave(group: String) -> AnyPublisher<Bool, Error> {
        return self.doLeave(group: group, with: nil)
    }
    public func doSetIdentity(using data: [String: Any?]) -> AnyPublisher<Bool, Error> {
        return self.doSetIdentity(using: data, with: nil)
    }

    // MARK: - Internal Work Methods
    open func intDoClearIdentity(with progress: DNSPTCLProgressBlock?,
                                 then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
    open func intDoJoin(group: String,
                        with progress: DNSPTCLProgressBlock?,
                        then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
    open func intDoLeave(group: String,
                         with progress: DNSPTCLProgressBlock?,
                         then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
    open func intDoSetIdentity(using data: [String: Any?],
                               with progress: DNSPTCLProgressBlock?,
                               then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
   }
}
