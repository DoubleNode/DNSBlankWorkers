//
//  WKRBlankAnnouncements.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankAnnouncements: WKRBlankBase, WKRPTCLAnnouncements {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLAnnouncements?

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLAnnouncements,
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
    @discardableResult
    public func runDoPub(runNext: DNSPTCLCallBlock?,
                         doWork: DNSPTCLCallResultBlock = { return $0?(.unhandled) }) -> Any? {
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Alerts.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadAnnouncements(with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLAnnouncementsBlkAAnnouncement?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadAnnouncements(with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadAnnouncements(with: progress, and: block, then: $0)
        })
    }
    public func doLoadAnnouncements(for place: DAOPlace,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLAnnouncementsBlkAAnnouncement?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadAnnouncements(for: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadAnnouncements(for: place, with: progress, and: block, then: $0)
        })
    }
    public func doLoadCurrentAnnouncements(with progress: DNSPTCLProgressBlock?,
                                           and block: WKRPTCLAnnouncementsBlkAAnnouncementPlace?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadCurrentAnnouncements(with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadCurrentAnnouncements(with: progress, and: block, then: $0)
        })
    }
    public func doReact(with reaction: DNSReactionType,
                        to announcement: DAOAnnouncement,
                        for place: DAOPlace,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLAnnouncementsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doReact(with: reaction, to: announcement, for: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoReact(with: reaction, to: announcement, for: place, with: progress, and: block, then: $0)
        })
    }
    public func doReact(with reaction: DNSReactionType,
                        to announcement: DAOAnnouncement,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLAnnouncementsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doReact(with: reaction, to: announcement, with: progress, and: block)
        },
                   doWork: {
            return self.intDoReact(with: reaction, to: announcement, with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ announcement: DAOAnnouncement,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAnnouncementsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRemove(announcement, with: progress, and: block)
        },
                   doWork: {
            return self.intDoRemove(announcement, with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ announcement: DAOAnnouncement,
                         for place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAnnouncementsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRemove(announcement, for: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoRemove(announcement, for: place, with: progress, and: block, then: $0)
        })
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to announcement: DAOAnnouncement,
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAnnouncementsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUnreact(with: reaction, to: announcement, for: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUnreact(with: reaction, to: announcement, for: place, with: progress, and: block, then: $0)
        })
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to announcement: DAOAnnouncement,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAnnouncementsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUnreact(with: reaction, to: announcement, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUnreact(with: reaction, to: announcement, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ announcement: DAOAnnouncement,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAnnouncementsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(announcement, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(announcement, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ announcement: DAOAnnouncement,
                         for place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAnnouncementsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(announcement, for: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(announcement, for: place, with: progress, and: block, then: $0)
        })
    }
    public func doView(_ announcement: DAOAnnouncement,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLAnnouncementsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doView(announcement, with: progress, and: block)
        },
                   doWork: {
            return self.intDoView(announcement, with: progress, and: block, then: $0)
        })
    }
    public func doView(_ announcement: DAOAnnouncement,
                       for place: DAOPlace,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLAnnouncementsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doView(announcement, for: place, with: progress, and: block)
        },
                   doWork: {
            return self.intDoView(announcement, for: place, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadAnnouncements(with block: WKRPTCLAnnouncementsBlkAAnnouncement?) {
        self.doLoadAnnouncements(with: nil, and: block)
    }
    public func doLoadAnnouncements(for place: DAOPlace,
                                    with block: WKRPTCLAnnouncementsBlkAAnnouncement?) {
        self.doLoadAnnouncements(for: place, with: nil, and: block)
    }
    public func doLoadCurrentAnnouncements(with block: WKRPTCLAnnouncementsBlkAAnnouncementPlace?) {
        self.doLoadCurrentAnnouncements(with: nil, and: block)
    }
    public func doReact(with reaction: DNSReactionType,
                        to announcement: DAOAnnouncement,
                        for place: DAOPlace,
                        with block: WKRPTCLAnnouncementsBlkMeta?) {
        self.doReact(with: reaction, to: announcement, for: place, with: nil, and: block)
    }
    public func doReact(with reaction: DNSReactionType,
                        to announcement: DAOAnnouncement,
                        with block: WKRPTCLAnnouncementsBlkMeta?) {
        self.doReact(with: reaction, to: announcement, with: nil, and: block)
    }
    public func doRemove(_ announcement: DAOAnnouncement,
                         with block: WKRPTCLAnnouncementsBlkVoid?) {
        self.doRemove(announcement, with: nil, and: block)
    }
    public func doRemove(_ announcement: DAOAnnouncement,
                         for place: DAOPlace,
                         with block: WKRPTCLAnnouncementsBlkVoid?) {
        self.doRemove(announcement, for: place, with: nil, and: block)
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to announcement: DAOAnnouncement,
                          for place: DAOPlace,
                          with block: WKRPTCLAnnouncementsBlkMeta?) {
        self.doUnreact(with: reaction, to: announcement, for: place, with: nil, and: block)
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to announcement: DAOAnnouncement,
                          with block: WKRPTCLAnnouncementsBlkMeta?) {
        self.doUnreact(with: reaction, to: announcement, with: nil, and: block)
    }
    public func doUpdate(_ announcement: DAOAnnouncement,
                         with block: WKRPTCLAnnouncementsBlkVoid?) {
        self.doUpdate(announcement, with: nil, and: block)
    }
    public func doUpdate(_ announcement: DAOAnnouncement,
                         for place: DAOPlace,
                         with block: WKRPTCLAnnouncementsBlkVoid?) {
        self.doUpdate(announcement, for: place, with: nil, and: block)
    }
    public func doView(_ announcement: DAOAnnouncement,
                       with block: WKRPTCLAnnouncementsBlkMeta?) {
        self.doView(announcement, with: nil, and: block)
    }
    public func doView(_ announcement: DAOAnnouncement,
                       for place: DAOPlace,
                       with block: WKRPTCLAnnouncementsBlkMeta?) {
        self.doView(announcement, for: place, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadAnnouncements(with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLAnnouncementsBlkAAnnouncement?,
                                     then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadAnnouncements(for place: DAOPlace,
                                     with progress: DNSPTCLProgressBlock?,
                                     and block: WKRPTCLAnnouncementsBlkAAnnouncement?,
                                     then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadCurrentAnnouncements(with progress: DNSPTCLProgressBlock?,
                                            and block: WKRPTCLAnnouncementsBlkAAnnouncementPlace?,
                                            then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoReact(with reaction: DNSReactionType,
                         to announcement: DAOAnnouncement,
                         for place: DAOPlace,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAnnouncementsBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoReact(with reaction: DNSReactionType,
                         to announcement: DAOAnnouncement,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLAnnouncementsBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemove(_ announcement: DAOAnnouncement,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAnnouncementsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoRemove(_ announcement: DAOAnnouncement,
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAnnouncementsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUnreact(with reaction: DNSReactionType,
                           to announcement: DAOAnnouncement,
                           for place: DAOPlace,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLAnnouncementsBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUnreact(with reaction: DNSReactionType,
                           to announcement: DAOAnnouncement,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLAnnouncementsBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ announcement: DAOAnnouncement,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAnnouncementsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ announcement: DAOAnnouncement,
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLAnnouncementsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoView(_ announcement: DAOAnnouncement,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLAnnouncementsBlkMeta?,
                        then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoView(_ announcement: DAOAnnouncement,
                        for place: DAOPlace,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLAnnouncementsBlkMeta?,
                        then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
