//
//  WKRBlankPermissions.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSError
import DNSProtocols

open class WKRBlankPermissions: WKRBasePermissions {
   // MARK: - Internal Work Methods
    override open func intDoRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                           _ permission: WKRPTCLPermissions.Data.System,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLPermissionsBlkAction?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(WKRPTCLPermissionAction(.none, .unknown)))
        _ = resultBlock?(.completed)
    }
    override open func intDoRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                           _ permissions: [WKRPTCLPermissions.Data.System],
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLPermissionsBlkAAction?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoStatus(of permissions: [WKRPTCLPermissions.Data.System],
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLPermissionsBlkAAction?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoWait(for permission: WKRPTCLPermissions.Data.System,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLPermissionsBlkAction?,
                        then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(WKRPTCLPermissionAction(.none, .unknown)))
        _ = resultBlock?(.completed)
    }
}
