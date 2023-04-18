//
//  WKRBlankPermissions.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSError
import DNSProtocols

open class WKRBlankPermissions: WKRBlankBase, WKRPTCLPermissions {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLPermissions?

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
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
                      doWork: DNSPTCLCallResultBlock = { return $0?(.unhandled) }) -> Any? {
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Permissions.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                          _ permission: WKRPTCLPermissions.Data.System,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPermissionsBlkAction?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRequest(desire, permission, with: progress, and: block)
        },
                   doWork: {
            return self.intDoRequest(desire, permission, with: progress, and: block, then: $0)
        })
    }
    public func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                          _ permissions: [WKRPTCLPermissions.Data.System],
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPermissionsBlkAAction?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRequest(desire, permissions, with: progress, and: block)
        },
                   doWork: {
            return self.intDoRequest(desire, permissions, with: progress, and: block, then: $0)
        })
    }
    public func doStatus(of permissions: [WKRPTCLPermissions.Data.System],
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLPermissionsBlkAAction?) {
        self.runDo(runNext: {
            return self.nextWorker?.doStatus(of: permissions, with: progress, and: block)
        },
                   doWork: {
            return self.intDoStatus(of: permissions, with: progress, and: block, then: $0)
        })
    }
    public func doWait(for permission: WKRPTCLPermissions.Data.System,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLPermissionsBlkAction?) {
        self.runDo(runNext: {
            return self.nextWorker?.doWait(for: permission, with: progress, and: block)
        },
                   doWork: {
            return self.intDoWait(for: permission, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                          _ permission: WKRPTCLPermissions.Data.System,
                          with block: WKRPTCLPermissionsBlkAction?) {
        self.doRequest(desire, permission, with: nil, and: block)
    }
    public func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                          _ permissions: [WKRPTCLPermissions.Data.System],
                          with block: WKRPTCLPermissionsBlkAAction?) {
        self.doRequest(desire, permissions, with: nil, and: block)
    }
    public func doStatus(of permissions: [WKRPTCLPermissions.Data.System],
                         with block: WKRPTCLPermissionsBlkAAction?) {
        self.doStatus(of: permissions, with: nil, and: block)
    }
    public func doWait(for permission: WKRPTCLPermissions.Data.System,
                       with block: WKRPTCLPermissionsBlkAction?) {
        self.doWait(for: permission, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                           _ permission: WKRPTCLPermissions.Data.System,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLPermissionsBlkAction?,
                           then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                           _ permissions: [WKRPTCLPermissions.Data.System],
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLPermissionsBlkAAction?,
                           then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoStatus(of permissions: [WKRPTCLPermissions.Data.System],
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPermissionsBlkAAction?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoWait(for permission: WKRPTCLPermissions.Data.System,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLPermissionsBlkAction?,
                        then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
