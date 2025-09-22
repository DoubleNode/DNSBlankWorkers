//
//  WKRBlankAlerts.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankAlerts: WKRBlankBase, WKRPTCLAlerts {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAlerts? {
        get { return nextBaseWorker as? WKRPTCLAlerts }
        set { nextBaseWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLAlerts,
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
        if case DNSError.Alerts.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadAlerts(for place: DAOPlace,
                             with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert {
        return self.runDoPub(runNext: {
            guard self.nextWorker != nil else {
                return WKRPTCLAlertsFutAAlert { $0(.success([])) }.eraseToAnyPublisher()
            }
            return self.nextWorker?.doLoadAlerts(for: place, with: progress)
        },
                             doWork: {
            return self.intDoLoadAlerts(for: place, with: progress, then: $0)
        }) as! WKRPTCLAlertsPubAAlert // swiftlint:disable:this force_cast
    }
    public func doLoadAlerts(for section: DAOSection,
                             with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert {
        return self.runDoPub(runNext: {
            guard self.nextWorker != nil else {
                return WKRPTCLAlertsFutAAlert { $0(.success([])) }.eraseToAnyPublisher()
            }
            return self.nextWorker?.doLoadAlerts(for: section, with: progress)
        },
                             doWork: {
            return self.intDoLoadAlerts(for: section, with: progress, then: $0)
        }) as! WKRPTCLAlertsPubAAlert // swiftlint:disable:this force_cast
    }
    public func doLoadAlerts(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert {
        return self.runDoPub(runNext: {
            guard self.nextWorker != nil else {
                return WKRPTCLAlertsFutAAlert { $0(.success([])) }.eraseToAnyPublisher()
            }
            return self.nextWorker?.doLoadAlerts(with: progress)
        },
                             doWork: {
            return self.intDoLoadAlerts(with: progress, then: $0)
        }) as! WKRPTCLAlertsPubAAlert // swiftlint:disable:this force_cast
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadAlerts(for place: DAOPlace) -> WKRPTCLAlertsPubAAlert {
        return self.doLoadAlerts(for: place, with: nil)
    }
    public func doLoadAlerts(for section: DAOSection) -> WKRPTCLAlertsPubAAlert {
        return self.doLoadAlerts(for: section, with: nil)
    }
    public func doLoadAlerts() -> WKRPTCLAlertsPubAAlert {
        return self.doLoadAlerts(with: nil)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadAlerts(for place: DAOPlace,
                              with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAlertsPubAAlert {
        _ = resultBlock?(.completed)
        return WKRPTCLAlertsFutAAlert { $0(.success([])) }.eraseToAnyPublisher()
    }
    open func intDoLoadAlerts(for section: DAOSection,
                              with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAlertsPubAAlert {
        _ = resultBlock?(.completed)
        return WKRPTCLAlertsFutAAlert { $0(.success([])) }.eraseToAnyPublisher()
    }
    open func intDoLoadAlerts(with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAlertsPubAAlert {
        _ = resultBlock?(.completed)
        return WKRPTCLAlertsFutAAlert { $0(.success([])) }.eraseToAnyPublisher()
    }
}
