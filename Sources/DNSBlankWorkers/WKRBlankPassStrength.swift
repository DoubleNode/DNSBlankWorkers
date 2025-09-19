//
//  WKRBlankPassStrength.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import DNSProtocols
import Foundation

open class WKRBlankPassStrength: WKRBlankBase, WKRPTCLPassStrength {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled

    public var nextWKRPTCLPassStrength: WKRPTCLPassStrength? {
        get { return nextWorker as? WKRPTCLPassStrength }
        set { nextWorker = newValue }
    }

    public var minimumLength: Int32 = 6

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLPassStrength,
                         for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.callNextWhen = callNextWhen
        self.nextWKRPTCLPassStrength = nextWorker
    }

    override open func disableOption(_ option: String) {
        super.disableOption(option)
        nextWKRPTCLPassStrength?.disableOption(option)
    }
    override open func enableOption(_ option: String) {
        super.enableOption(option)
        nextWKRPTCLPassStrength?.enableOption(option)
    }
    @discardableResult
    public func runDo(runNext: DNSPTCLCallBlock?,
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWKRPTCLPassStrength != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.PassStrength.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doCheckPassStrength(for password: String) -> WKRPTCLPassStrengthResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLPassStrength?.doCheckPassStrength(for: password)
        },
                          doWork: {
            return self.intDoCheckPassStrength(for: password, then: $0)
        }) as! WKRPTCLPassStrengthResVoid // swiftlint:disable:this force_cast
    }

    // MARK: - Internal Work Methods
    open func intDoCheckPassStrength(for password: String,
                                     then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLPassStrengthResVoid {
        _ = resultBlock?(.completed)
        return .success(WKRPTCLPassStrength.Level.weak)
    }
}
