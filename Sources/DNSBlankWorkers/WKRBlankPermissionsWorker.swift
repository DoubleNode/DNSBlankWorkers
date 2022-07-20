//
//  WKRBlankPermissionsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSProtocols

open class WKRBlankPermissionsWorker: WKRBlankBaseWorker, WKRPTCLPermissions {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLPermissions?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLPermissions,
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

    // MARK: - Worker Logic (Public) -
    public func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                          _ permission: WKRPTCLPermissions.Data.System,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPermissionsBlkAction?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doRequest(desire, permission, with: progress, and: block)
        },
        doWork: {
            return try self.intDoRequest(desire, permission, with: progress, and: block, then: $0)
        })
    }
    public func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                          _ permissions: [WKRPTCLPermissions.Data.System],
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPermissionsBlkAAction?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doRequest(desire, permissions, with: progress, and: block)
        },
        doWork: {
            return try self.intDoRequest(desire, permissions, with: progress, and: block, then: $0)
        })
    }
    public func doStatus(of permissions: [WKRPTCLPermissions.Data.System],
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPermissionsBlkAAction?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doStatus(of: permissions, with: progress, and: block)
        },
        doWork: {
            return try self.intDoStatus(of: permissions, with: progress, and: block, then: $0)
        })
    }
    public func doWait(for permission: WKRPTCLPermissions.Data.System,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLPermissionsBlkAction?) throws {
        try self.runDo(runNext: {
            return try self.nextWorker?.doWait(for: permission, with: progress, and: block)
        },
        doWork: {
            return try self.intDoWait(for: permission, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                          _ permission: WKRPTCLPermissions.Data.System,
                          with block: WKRPTCLPermissionsBlkAction?) throws {
        try self.doRequest(desire, permission, with: nil, and: block)
    }
    public func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                          _ permissions: [WKRPTCLPermissions.Data.System],
                          with block: WKRPTCLPermissionsBlkAAction?) throws {
        try self.doRequest(desire, permissions, with: nil, and: block)
    }
    public func doStatus(of permissions: [WKRPTCLPermissions.Data.System],
                         with block: WKRPTCLPermissionsBlkAAction?) throws {
        try self.doStatus(of: permissions, with: nil, and: block)
    }
    public func doWait(for permission: WKRPTCLPermissions.Data.System,
                       with block: WKRPTCLPermissionsBlkAction?) throws {
        try self.doWait(for: permission, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                           _ permission: WKRPTCLPermissions.Data.System,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLPermissionsBlkAction?,
                           then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                           _ permissions: [WKRPTCLPermissions.Data.System],
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLPermissionsBlkAAction?,
                           then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoStatus(of permissions: [WKRPTCLPermissions.Data.System],
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPermissionsBlkAAction?,
                          then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoWait(for permission: WKRPTCLPermissions.Data.System,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLPermissionsBlkAction?,
                        then resultBlock: DNSPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
