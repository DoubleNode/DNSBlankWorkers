//
//  WKRBasePassports.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBasePassports: WKRBaseWorker, WKRPTCLPassports {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLPassports? {
        get { return nextBaseWorker as? WKRPTCLPassports }
        set { nextBaseWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLPassports,
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
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    @discardableResult
    public func runDoPub(runNext: DNSPTCLCallBlock?,
                         doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Passports.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doBuildPassport(ofType passportType: String,
                                using data: [String: String],
                                for account: DAOAccount,
                                with progress: DNSPTCLProgressBlock?) -> WKRPTCLPassportsPubData {
        return self.runDoPub(runNext: {
            guard self.nextWorker != nil else {
                return WKRPTCLPassportsFutData { $0(.success(Data())) }.eraseToAnyPublisher()
            }
            return self.nextWorker?.doBuildPassport(ofType: passportType, using: data, for: account, with: progress)
        },
                             doWork: {
            return self.intDoBuildPassport(ofType: passportType, using: data, for: account, with: progress, then: $0)
        }) as! WKRPTCLPassportsPubData // swiftlint:disable:this force_cast
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doBuildPassport(ofType passportType: String,
                                using data: [String: String],
                                for account: DAOAccount) -> WKRPTCLPassportsPubData {
        return self.doBuildPassport(ofType: passportType, using: data, for: account, with: nil)
    }

    // MARK: - Internal Work Methods
    open func intDoBuildPassport(ofType passportType: String,
                                 using data: [String: String],
                                 for account: DAOAccount,
                                 with progress: DNSPTCLProgressBlock?,
                                 then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLPassportsPubData {
        return resultBlock?(.unhandled) as! WKRPTCLPassportsPubData // swiftlint:disable:this force_cast
    }
}
