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

open class WKRBlankChats: WKRBaseChats {
    // MARK: - Internal Work Methods
    override open func intDoLoadChat(for id: String,
                            with progress: DNSPTCLProgressBlock?,
                            and block: WKRPTCLChatsBlkChat?,
                            then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOChat()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadMessages(for chat: DAOChat,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLChatsBlkAChatMessage?,
                                then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoReact(with reaction: DNSReactionType,
                         to chat: DAOChat,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLChatsBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoRemove(_ message: DAOChatMessage,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLChatsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUnreact(with reaction: DNSReactionType,
                           to chat: DAOChat,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLChatsBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ message: DAOChatMessage,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLChatsBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
