//
//  WKRBlankSections.swift
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

open class WKRBlankSections: WKRBaseSections {
    // MARK: - Internal Work Methods
    override open func intDoLoadChildren(for section: DAOSection,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLSectionsBlkASection?,
                                then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadParent(for section: DAOSection,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLSectionsBlkSection?,
                              then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOSection()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadSection(for id: String,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLSectionsBlkSection?,
                               then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOSection()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadSections(with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLSectionsBlkASection?,
                                then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoReact(with reaction: DNSReactionType,
                         to section: DAOSection,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLSectionsBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUnreact(with reaction: DNSReactionType,
                           to section: DAOSection,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLSectionsBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ section: DAOSection,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLSectionsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
