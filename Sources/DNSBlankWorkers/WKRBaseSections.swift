//
//  WKRBaseSections.swift
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

open class WKRBaseSections: WKRBaseWorker, WKRPTCLSections {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLSections? {
        get { return nextBaseWorker as? WKRPTCLSections }
        set { nextBaseWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLSections,
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
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWorker != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    @discardableResult
    public func runDoPub(runNext: DNSPTCLCallBlock?,
                         doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Sections.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadChildren(for section: DAOSection,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLSectionsBlkASection?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadChildren(for: section, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadChildren(for: section, with: progress, and: block, then: $0)
        })
    }
    public func doLoadParent(for section: DAOSection,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLSectionsBlkSection?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadParent(for: section, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadParent(for: section, with: progress, and: block, then: $0)
        })
    }
    public func doLoadSection(for id: String,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLSectionsBlkSection?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadSection(for: id, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadSection(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadSections(with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLSectionsBlkASection?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadSections(with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadSections(with: progress, and: block, then: $0)
        })
    }
    public func doReact(with reaction: DNSReactionType,
                        to section: DAOSection,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLSectionsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doReact(with: reaction, to: section, with: progress, and: block)
        },
                   doWork: {
            return self.intDoReact(with: reaction, to: section, with: progress, and: block, then: $0)
        })
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to section: DAOSection,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLSectionsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUnreact(with: reaction, to: section, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUnreact(with: reaction, to: section, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ section: DAOSection,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLSectionsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(section, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(section, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadChildren(for section: DAOSection,
                               with block: WKRPTCLSectionsBlkASection?) {
        self.doLoadChildren(for: section, with: nil, and: block)
    }
    public func doLoadParent(for section: DAOSection,
                             with block: WKRPTCLSectionsBlkSection?) {
        self.doLoadParent(for: section, with: nil, and: block)
    }
    public func doLoadSection(for id: String,
                              with block: WKRPTCLSectionsBlkSection?) {
        self.doLoadSection(for: id, with: nil, and: block)
    }
    public func doLoadSections(with block: WKRPTCLSectionsBlkASection?) {
        self.doLoadSections(with: nil, and: block)
    }
    public func doReact(with reaction: DNSReactionType,
                        to section: DAOSection,
                        with block: WKRPTCLSectionsBlkMeta?) {
        self.doReact(with: reaction, to: section, with: nil, and: block)
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to section: DAOSection,
                          with block: WKRPTCLSectionsBlkMeta?) {
        self.doUnreact(with: reaction, to: section, with: nil, and: block)
    }
    public func doUpdate(_ section: DAOSection,
                         with block: WKRPTCLSectionsBlkVoid?) {
        self.doUpdate(section, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadChildren(for section: DAOSection,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLSectionsBlkASection?,
                                then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadParent(for section: DAOSection,
                              with progress: DNSPTCLProgressBlock?,
                              and block: WKRPTCLSectionsBlkSection?,
                              then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadSection(for id: String,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLSectionsBlkSection?,
                               then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoLoadSections(with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLSectionsBlkASection?,
                                then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoReact(with reaction: DNSReactionType,
                         to section: DAOSection,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLSectionsBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUnreact(with reaction: DNSReactionType,
                           to section: DAOSection,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLSectionsBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpdate(_ section: DAOSection,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLSectionsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
