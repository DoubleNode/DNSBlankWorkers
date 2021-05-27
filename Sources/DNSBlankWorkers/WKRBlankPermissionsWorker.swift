//
//  WKRBlankPermissionsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSProtocols

open class WKRBlankPermissionsWorker: WKRBlankBaseWorker, PTCLPermissions_Protocol
{
    public var callNextWhen: PTCLCallNextWhen = .whenUnhandled
    public var nextWorker: PTCLPermissions_Protocol?

    public required init() {
        super.init()
    }
    public func register(nextWorker: PTCLPermissions_Protocol,
                         for callNextWhen: PTCLCallNextWhen) {
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
    public func runDo(runNext: PTCLCallBlock?,
                      doWork: PTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Protocol Interface Methods
    public func doRequest(_ desire: PTCLPermissions.Desire,
                          _ permission: PTCLPermissions.Permission,
                          with progress: PTCLProgressBlock?,
                          and block: PTCLPermissionsBlockVoidPTCLPermissionActionError?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doRequest(desire, permission, with: progress, and: block)
        },
        doWork: {
            return try self.intDoRequest(desire, permission, with: progress, and: block, then: $0)
        })
    }
    public func doRequest(_ desire: PTCLPermissions.Desire,
                          _ permissions: [PTCLPermissions.Permission],
                          with progress: PTCLProgressBlock?,
                          and block: PTCLPermissionsBlockVoidArrayPTCLPermissionActionError?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doRequest(desire, permissions, with: progress, and: block)
        },
        doWork: {
            return try self.intDoRequest(desire, permissions, with: progress, and: block, then: $0)
        })
    }
    public func doStatus(of permissions: [PTCLPermissions.Permission],
                         with progress: PTCLProgressBlock?,
                         and block: PTCLPermissionsBlockVoidArrayPTCLPermissionActionError?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doStatus(of: permissions, with: progress, and: block)
        },
        doWork: {
            return try self.intDoStatus(of: permissions, with: progress, and: block, then: $0)
        })
    }
    public func doWait(for permission: PTCLPermissions.Permission,
                       with progress: PTCLProgressBlock?,
                       and block: PTCLPermissionsBlockVoidPTCLPermissionActionError?) throws {
        try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doWait(for: permission, with: progress, and: block)
        },
        doWork: {
            return try self.intDoWait(for: permission, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Internal Work Methods
    open func intDoRequest(_ desire: PTCLPermissions.Desire,
                           _ permission: PTCLPermissions.Permission,
                           with progress: PTCLProgressBlock?,
                           and block: PTCLPermissionsBlockVoidPTCLPermissionActionError?,
                           then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRequest(_ desire: PTCLPermissions.Desire,
                           _ permissions: [PTCLPermissions.Permission],
                           with progress: PTCLProgressBlock?,
                           and block: PTCLPermissionsBlockVoidArrayPTCLPermissionActionError?,
                           then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoStatus(of permissions: [PTCLPermissions.Permission],
                          with progress: PTCLProgressBlock?,
                          and block: PTCLPermissionsBlockVoidArrayPTCLPermissionActionError?,
                          then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
    open func intDoWait(for permission: PTCLPermissions.Permission,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLPermissionsBlockVoidPTCLPermissionActionError?,
                        then resultBlock: PTCLResultBlock?) throws {
        _ = resultBlock?(.unhandled)
    }
}
