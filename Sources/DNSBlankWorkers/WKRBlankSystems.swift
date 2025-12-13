//
//  WKRBlankSystems.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSDataObjects
import DNSDataTypes
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankSystems: WKRBaseSystems {
    // MARK: - Internal Work Methods
    override open func intDoConfigure(with progress: DNSPTCLProgressBlock?,
                                      and block: WKRPTCLSystemsBlkVoid?,
                                      then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadSystem(for id: String,
                                       with progress: DNSPTCLProgressBlock?,
                                       and block: WKRPTCLSystemsBlkSystem?,
                                       then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOSystem()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadDebugStrings(for system: DAOSystem,
                                             and endPoint: String,
                                             with failureCode: String,
                                             at timestamp: Date,
                                             for platform: WKRPTCLSystemsData.Platform?,
                                             limit: Int,
                                             offset: Int,
                                             with progress: DNSPTCLProgressBlock?,
                                             and block: WKRPTCLSystemsBlkASystemDebugString?,
                                             then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadEndPoints(for system: DAOSystem,
                                          with progress: DNSPTCLProgressBlock?,
                                          and block: WKRPTCLSystemsBlkASystemEndPoint?,
                                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadHistory(for system: DAOSystem,
                                        since time: Date,
                                        with progress: DNSPTCLProgressBlock?,
                                        and block: WKRPTCLSystemsBlkASystemState?,
                                        then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadHistory(for endPoint: DAOSystemEndPoint,
                                        since time: Date,
                                        include failureCodes: Bool,
                                        with progress: DNSPTCLProgressBlock?,
                                        and block: WKRPTCLSystemsBlkASystemState?,
                                        then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadSystems(with progress: DNSPTCLProgressBlock?,
                                        and block: WKRPTCLSystemsBlkASystem?,
                                        then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoOverride(system: DAOSystem,
                                     with state: DNSSystemState,
                                     with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLSystemsBlkSystem?,
                                     then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOSystem()))
        _ = resultBlock?(.completed)
    }
    override open func intDoReact(with reaction: DNSReactionType,
                                  to system: DAOSystem,
                                  with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLSystemsBlkMeta?,
                                  then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoReport(result: WKRPTCLSystemsData.Result,
                                   and failureCode: String,
                                   and debugString: String,
                                   for systemId: String,
                                   and endPointId: String,
                                   with progress: DNSPTCLProgressBlock?,
                                   then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLSystemsPubVoid {
        _ = resultBlock?(.completed)
        return WKRPTCLSystemsFutVoid { $0(.success) }.eraseToAnyPublisher()
    }
    override open func intDoUnreact(with reaction: DNSReactionType,
                                    to system: DAOSystem,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLSystemsBlkMeta?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
}
