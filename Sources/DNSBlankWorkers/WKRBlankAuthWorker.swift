//
//  WKRBlankAuthWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankAuthWorker: WKRBlankBaseWorker, WKRPTCLAuth {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAuth?

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystemsWorker()
    }
    public func register(nextWorker: WKRPTCLAuth,
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
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Auth.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doCheckAuth(using parameters: DNSDataDictionary,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLAuthBlkBoolBoolAccessData?) {
        self.runDo(runNext: {
            return self.nextWorker?.doCheckAuth(using: parameters,
                                                with: progress, and: block)
        },
        doWork: {
            return self.intDoCheckAuth(using: parameters,
                                       with: progress, and: block, then: $0)
        })
    }
    public func doSignIn(from username: String?,
                         and password: String?,
                         using parameters: DNSDataDictionary,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAuthBlkBoolAccessData?) {
        self.runDo(runNext: {
            return self.nextWorker?.doSignIn(from: username, and: password, using: parameters,
                                             with: progress, and: block)
        },
        doWork: {
            return self.intDoSignIn(from: username, and: password, using: parameters,
                                    with: progress, and: block, then: $0)
        })
    }
    public func doSignOut(using parameters: DNSDataDictionary,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAuthBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doSignOut(using: parameters, with: progress, and: block)
        },
        doWork: {
            return self.intDoSignOut(using: parameters, with: progress, and: block, then: $0)
        })
    }
    public func doSignUp(from user: DAOUser?,
                         and password: String?,
                         using parameters: DNSDataDictionary,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAuthBlkBoolAccessData?) {
        self.runDo(runNext: {
            return self.nextWorker?.doSignUp(from: user, and: password, using: parameters,
                                             with: progress, and: block)
        },
        doWork: {
            return self.intDoSignUp(from: user, and: password, using: parameters,
                                    with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doCheckAuth(using parameters: DNSDataDictionary,
                            with block: WKRPTCLAuthBlkBoolBoolAccessData?) {
        self.doCheckAuth(using: parameters, with: nil, and: block)
    }
    public func doSignIn(from username: String?,
                         and password: String?,
                         using parameters: DNSDataDictionary,
                         with block: WKRPTCLAuthBlkBoolAccessData?) {
        self.doSignIn(from: username, and: password, using: parameters, with: nil, and: block)
    }
    public func doSignOut(using parameters: DNSDataDictionary,
                          with block: WKRPTCLAuthBlkVoid?) {
        self.doSignOut(using: parameters, with: nil, and: block)
    }
    public func doSignUp(from user: DAOUser?,
                         and password: String?,
                         using parameters: DNSDataDictionary,
                         with block: WKRPTCLAuthBlkBoolAccessData?) {
        self.doSignUp(from: user, and: password, using: parameters, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoCheckAuth(using parameters: DNSDataDictionary,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLAuthBlkBoolBoolAccessData?,
                             then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoSignIn(from username: String?,
                          and password: String?,
                          using parameters: DNSDataDictionary,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAuthBlkBoolAccessData?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoSignOut(using parameters: DNSDataDictionary,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLAuthBlkVoid?,
                           then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoSignUp(from user: DAOUser?,
                          and password: String?,
                          using parameters: DNSDataDictionary,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAuthBlkBoolAccessData?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
