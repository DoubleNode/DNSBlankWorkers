//
//  WKRBlankAuth.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataContracts
import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

public struct WKRBlankAuthAccessData: WKRPTCLAuth.AccessData {
    public let accessToken: String = ""
}
open class WKRBlankAuth: WKRBlankBase, WKRPTCLAuth {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled

    public var nextWKRPTCLAuth: WKRPTCLAuth? {
        get { return nextWorker as? WKRPTCLAuth }
        set { nextWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLAuth,
                         for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.callNextWhen = callNextWhen
        self.nextWKRPTCLAuth = nextWorker
    }

    override open func disableOption(_ option: String) {
        super.disableOption(option)
        nextWKRPTCLAuth?.disableOption(option)
    }
    override open func enableOption(_ option: String) {
        super.enableOption(option)
        nextWKRPTCLAuth?.enableOption(option)
    }
    @discardableResult
    public func runDo(runNext: DNSPTCLCallBlock?,
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWKRPTCLAuth != nil) ? runNext : nil
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
            return self.nextWKRPTCLAuth?.doCheckAuth(using: parameters,
                                                with: progress, and: block)
        },
                   doWork: {
            return self.intDoCheckAuth(using: parameters,
                                       with: progress, and: block, then: $0)
        })
    }
    public func doLinkAuth(from username: String,
                           and password: String,
                           using parameters: DNSDataDictionary,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLAuthBlkBoolAccessData?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAuth?.doLinkAuth(from: username,
                                               and: password,
                                               using: parameters,
                                               with: progress, and: block)
        },
                   doWork: {
            return self.intDoLinkAuth(from: username, and: password,
                                      using: parameters,
                                      with: progress, and: block, then: $0)
        })
    }
    public func doPasswordResetStart(from username: String?,
                                     using parameters: DNSDataDictionary,
                                     with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLAuthBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAuth?.doPasswordResetStart(from: username, using: parameters,
                                                         with: progress, and: block)
        },
                   doWork: {
            return self.intDoPasswordResetStart(from: username, using: parameters,
                                                with: progress, and: block, then: $0)
        })
    }
    public func doSignIn(from username: String?,
                         and password: String?,
                         using parameters: DNSDataDictionary,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAuthBlkBoolAccessData?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAuth?.doSignIn(from: username, and: password, using: parameters,
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
            return self.nextWKRPTCLAuth?.doSignOut(using: parameters, with: progress, and: block)
        },
                   doWork: {
            return self.intDoSignOut(using: parameters, with: progress, and: block, then: $0)
        })
    }
    public func doSignUp(from user: (any DAOUserProtocol)?,
                         and password: String?,
                         using parameters: DNSDataDictionary,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAuthBlkBoolAccessData?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLAuth?.doSignUp(from: user, and: password, using: parameters,
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
    public func doLinkAuth(from username: String,
                           and password: String,
                           using parameters: DNSDataDictionary,
                           and block: WKRPTCLAuthBlkBoolAccessData?) {
        self.doLinkAuth(from: username, and: password, using: parameters,
                        with: nil, and: block)
    }
    public func doPasswordResetStart(from username: String?,
                                     using parameters: DNSDataDictionary,
                                     with block: WKRPTCLAuthBlkVoid?) {
        self.doPasswordResetStart(from: username, using: parameters, with: nil, and: block)
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
    public func doSignUp(from user: (any DAOUserProtocol)?,
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
        block?(.success((false, false, WKRBlankAuthAccessData())))
        _ = resultBlock?(.completed)
    }
    open func intDoLinkAuth(from username: String,
                            and password: String,
                            using parameters: DNSDataDictionary,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLAuthBlkBoolAccessData?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success((false, WKRBlankAuthAccessData())))
        _ = resultBlock?(.completed)
    }
    open func intDoPasswordResetStart(from username: String?,
                                      using parameters: DNSDataDictionary,
                                      with progress: DNSPTCLProgressBlock?,
                                      and block: WKRPTCLAuthBlkVoid?,
                                      then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoSignIn(from username: String?,
                          and password: String?,
                          using parameters: DNSDataDictionary,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAuthBlkBoolAccessData?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success((false, WKRBlankAuthAccessData())))
        _ = resultBlock?(.completed)
    }
    open func intDoSignOut(using parameters: DNSDataDictionary,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLAuthBlkVoid?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoSignUp(from user: (any DAOUserProtocol)?,
                          and password: String?,
                          using parameters: DNSDataDictionary,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAuthBlkBoolAccessData?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success((false, WKRBlankAuthAccessData())))
        _ = resultBlock?(.completed)
    }
}
