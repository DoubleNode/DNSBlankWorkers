//
//  WKRBlankAnnouncements.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import DNSDataTypes
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankAnnouncements: WKRBaseAnnouncements {
    // MARK: - Internal Work Methods
    override open func intDoLoadAnnouncements(with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLAnnouncementsBlkAAnnouncement?,
                                     then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadAnnouncements(for place: DAOPlace,
                                     with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLAnnouncementsBlkAAnnouncement?,
                                     then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadCurrentAnnouncements(with progress: DNSPTCLProgressBlock?,
                                            and block: WKRPTCLAnnouncementsBlkAAnnouncementPlace?,
                                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(([], [])))
        _ = resultBlock?(.completed)
    }
    override open func intDoReact(with reaction: DNSReactionType,
                         to announcement: DAOAnnouncement,
                         for place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAnnouncementsBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoReact(with reaction: DNSReactionType,
                         to announcement: DAOAnnouncement,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAnnouncementsBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoRemove(_ announcement: DAOAnnouncement,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAnnouncementsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoRemove(_ announcement: DAOAnnouncement,
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAnnouncementsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUnreact(with reaction: DNSReactionType,
                           to announcement: DAOAnnouncement,
                           for place: DAOPlace,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLAnnouncementsBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUnreact(with reaction: DNSReactionType,
                           to announcement: DAOAnnouncement,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLAnnouncementsBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ announcement: DAOAnnouncement,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAnnouncementsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ announcement: DAOAnnouncement,
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAnnouncementsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoView(_ announcement: DAOAnnouncement,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLAnnouncementsBlkMeta?,
                        then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoView(_ announcement: DAOAnnouncement,
                        for place: DAOPlace,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLAnnouncementsBlkMeta?,
                        then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
}
