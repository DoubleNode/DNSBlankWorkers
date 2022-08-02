//
//  WKRBlankAlertsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import DNSProtocols
import Foundation

open class WKRBlankAlertsWorker: WKRBlankBaseWorker, WKRPTCLAlerts {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAlerts?

    public required init() {
        super.init()
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
    public func doLoadAlerts(for place: DAOPlace,
                             with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert {
        // swiftlint:disable:next force_try
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLAlertsFutAAlert { $0(.success([])) }.eraseToAnyPublisher()
            }
            return nextWorker.doLoadAlerts(for: place, with: progress)
        },
                                  doWork: {
            return self.intDoLoadAlerts(for: place, with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAlertsPubAAlert
    }
    public func doLoadAlerts(for district: DAODistrict,
                             with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert {
        // swiftlint:disable:next force_try
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLAlertsFutAAlert { $0(.success([])) }.eraseToAnyPublisher()
            }
            return nextWorker.doLoadAlerts(for: district, with: progress)
        },
                                  doWork: {
            return self.intDoLoadAlerts(for: district, with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAlertsPubAAlert
    }
    public func doLoadAlerts(for region: DAORegion,
                             with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert {
        // swiftlint:disable:next force_try
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLAlertsFutAAlert { $0(.success([])) }.eraseToAnyPublisher()
            }
            return nextWorker.doLoadAlerts(for: region, with: progress)
        },
                                  doWork: {
            return self.intDoLoadAlerts(for: region, with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAlertsPubAAlert
    }
    public func doLoadAlerts(with progress: DNSPTCLProgressBlock?) -> WKRPTCLAlertsPubAAlert {
        // swiftlint:disable:next force_try
        return try! self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLAlertsFutAAlert { $0(.success([])) }.eraseToAnyPublisher()
            }
            return nextWorker.doLoadAlerts(with: progress)
        },
                                  doWork: {
            return self.intDoLoadAlerts(with: progress, then: $0)
            // swiftlint:disable:next force_cast
        }) as! WKRPTCLAlertsPubAAlert
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadAlerts(for place: DAOPlace) -> WKRPTCLAlertsPubAAlert {
        return self.doLoadAlerts(for: place, with: nil)
    }
    public func doLoadAlerts(for district: DAODistrict) -> WKRPTCLAlertsPubAAlert {
        return self.doLoadAlerts(for: district, with: nil)
    }
    public func doLoadAlerts(for region: DAORegion) -> WKRPTCLAlertsPubAAlert {
        return self.doLoadAlerts(for: region, with: nil)
    }
    public func doLoadAlerts() -> WKRPTCLAlertsPubAAlert {
        return self.doLoadAlerts(with: nil)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadAlerts(for place: DAOPlace,
                              with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAlertsPubAAlert {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! WKRPTCLAlertsPubAAlert
    }
    open func intDoLoadAlerts(for district: DAODistrict,
                              with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAlertsPubAAlert {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! WKRPTCLAlertsPubAAlert
    }
    open func intDoLoadAlerts(for region: DAORegion,
                              with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAlertsPubAAlert {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! WKRPTCLAlertsPubAAlert
    }
    open func intDoLoadAlerts(with progress: DNSPTCLProgressBlock?,
                              then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAlertsPubAAlert {
        // swiftlint:disable:next force_cast
        return resultBlock?(.unhandled) as! WKRPTCLAlertsPubAAlert
    }
}
