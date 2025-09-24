//
//  WKRBlankChats.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSDataTypes
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankChats: WKRBlankBase, WKRPTCLChats {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLChats? {
        get { return nextBaseWorker as? WKRPTCLChats }
        set { nextBaseWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLChats,
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
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Chats.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doLoadChat(for id: String,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLChatsBlkChat?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadChat(for: id, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadChat(for: id, with: progress, and: block, then: $0)
        })
    }
    public func doLoadMessages(for chat: DAOChat,
                               with progress: DNSPTCLProgressBlock?,
                               and block: WKRPTCLChatsBlkAChatMessage?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLoadMessages(for: chat, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLoadMessages(for: chat, with: progress, and: block, then: $0)
        })
    }
    public func doReact(with reaction: DNSReactionType,
                        to chat: DAOChat,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLChatsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doReact(with: reaction, to: chat, with: progress, and: block)
        },
                   doWork: {
            return self.intDoReact(with: reaction, to: chat, with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ message: DAOChatMessage,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLChatsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRemove(message, with: progress, and: block)
        },
                   doWork: {
            return self.intDoRemove(message, with: progress, and: block, then: $0)
        })
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to chat: DAOChat,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLChatsBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUnreact(with: reaction, to: chat, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUnreact(with: reaction, to: chat, with: progress, and: block, then: $0)
        })
    }
    public func doUpdate(_ message: DAOChatMessage,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLChatsBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpdate(message, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpdate(message, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLoadChat(for id: String,
                           with block: WKRPTCLChatsBlkChat?) {
        self.doLoadChat(for: id, with: nil, and: block)
    }
    public func doLoadMessages(for chat: DAOChat,
                               with block: WKRPTCLChatsBlkAChatMessage?) {
        self.doLoadMessages(for: chat, with: nil, and: block)
    }
    public func doReact(with reaction: DNSReactionType,
                        to chat: DAOChat,
                        with block: WKRPTCLChatsBlkMeta?) {
        self.doReact(with: reaction, to: chat, with: nil, and: block)
    }
    public func doRemove(_ message: DAOChatMessage,
                         with block: WKRPTCLChatsBlkVoid?) {
        self.doRemove(message, with: nil, and: block)
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to chat: DAOChat,
                          with block: WKRPTCLChatsBlkMeta?) {
        self.doUnreact(with: reaction, to: chat, with: nil, and: block)
    }
    public func doUpdate(_ message: DAOChatMessage,
                         with block: WKRPTCLChatsBlkVoid?) {
        self.doUpdate(message, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLoadChat(for id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLChatsBlkChat?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOChat()))
        _ = resultBlock?(.completed)
    }
    open func intDoLoadMessages(for chat: DAOChat,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLChatsBlkAChatMessage?,
                                then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    open func intDoReact(with reaction: DNSReactionType,
                         to chat: DAOChat,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLChatsBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    open func intDoRemove(_ message: DAOChatMessage,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLChatsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoUnreact(with reaction: DNSReactionType,
                           to chat: DAOChat,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLChatsBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    open func intDoUpdate(_ message: DAOChatMessage,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLChatsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
