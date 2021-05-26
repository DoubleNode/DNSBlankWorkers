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
    public required init(call callNextWhen: PTCLCallNextWhen,
                         nextWorker: PTCLPermissions_Protocol) {
        super.init()
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

    // MARK: - Business Logic / Single Item CRUD

    open func doRequest(_ desire: PTCLPermissions.Desire,
                        _ permission: PTCLPermissions.Permission,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLPermissionsBlockVoidPTCLPermissionActionError?) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doRequest(desire, permission, with: progress, and: block)
        }
    }
    open func doRequest(_ desire: PTCLPermissions.Desire,
                        _ permissions: [PTCLPermissions.Permission],
                        with progress: PTCLProgressBlock?,
                        and block: PTCLPermissionsBlockVoidArrayPTCLPermissionActionError?) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doRequest(desire, permissions, with: progress, and: block)
        }
    }
    open func doStatus(of permissions: [PTCLPermissions.Permission],
                       with progress: PTCLProgressBlock?,
                       and block: PTCLPermissionsBlockVoidArrayPTCLPermissionActionError?) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doStatus(of: permissions, with: progress, and: block)
        }
    }
    open func doWait(for permission: PTCLPermissions.Permission,
                     with progress: PTCLProgressBlock?,
                     and block: PTCLPermissionsBlockVoidPTCLPermissionActionError?) throws {
        try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doWait(for: permission, with: progress, and: block)
        }
    }
}
