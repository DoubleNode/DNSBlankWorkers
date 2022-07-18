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
    public var callNextWhen: WKRPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLPermissions?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLPermissions,
                         for callNextWhen: WKRPTCLWorker.Call.NextWhen) {
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
    public func runDo(runNext: WKRPTCLCallBlock?,
                      doWork: WKRPTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Protocol Interface Methods
    public func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                          _ permission: WKRPTCLPermissions.Data.System,
                          with progress: WKRPTCLProgressBlock?,
                          and block: WKRPTCLPermissionsBlockPermissionAction?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doRequest(desire, permission, with: progress, and: block)
        },
        doWork: {
            return try self.intDoRequest(desire, permission, with: progress, and: block, then: $0)
        })
    }
    public func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                          _ permissions: [WKRPTCLPermissions.Data.System],
                          with progress: WKRPTCLProgressBlock?,
                          and block: WKRPTCLPermissionsBlockArrayPermissionAction?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doRequest(desire, permissions, with: progress, and: block)
        },
        doWork: {
            return try self.intDoRequest(desire, permissions, with: progress, and: block, then: $0)
        })
    }
    public func doStatus(of permissions: [WKRPTCLPermissions.Data.System],
                         with progress: WKRPTCLProgressBlock?,
                         and block: WKRPTCLPermissionsBlockArrayPermissionAction?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doStatus(of: permissions, with: progress, and: block)
        },
        doWork: {
            return try self.intDoStatus(of: permissions, with: progress, and: block, then: $0)
        })
    }
    public func doWait(for permission: WKRPTCLPermissions.Data.System,
                       with progress: WKRPTCLProgressBlock?,
                       and block: WKRPTCLPermissionsBlockPermissionAction?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doWait(for: permission, with: progress, and: block)
        },
        doWork: {
            return try self.intDoWait(for: permission, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Internal Work Methods
    open func intDoRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                           _ permission: WKRPTCLPermissions.Data.System,
                           with progress: WKRPTCLProgressBlock?,
                           and block: WKRPTCLPermissionsBlockPermissionAction?,
                           then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                           _ permissions: [WKRPTCLPermissions.Data.System],
                           with progress: WKRPTCLProgressBlock?,
                           and block: WKRPTCLPermissionsBlockArrayPermissionAction?,
                           then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoStatus(of permissions: [WKRPTCLPermissions.Data.System],
                          with progress: WKRPTCLProgressBlock?,
                          and block: WKRPTCLPermissionsBlockArrayPermissionAction?,
                          then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoWait(for permission: WKRPTCLPermissions.Data.System,
                        with progress: WKRPTCLProgressBlock?,
                        and block: WKRPTCLPermissionsBlockPermissionAction?,
                        then resultBlock: WKRPTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
