//
//  WKRBlankMedia.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSDataTypes
import DNSError
import DNSProtocols
#if canImport(PDFKit)
import PDFKit
#endif
#if canImport(UIKit)
import UIKit
#endif

open class WKRBlankMedia: WKRBaseMedia {
    // MARK: - Internal Work Methods
    override open func intDoReact(with reaction: DNSReactionType,
                         to media: DAOMedia,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLMediaBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoRemove(_ media: DAOMedia,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUnreact(with reaction: DNSReactionType,
                           to media: DAOMedia,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLMediaBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUpload(from fileUrl: URL,
                          to path: String,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkMedia?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOMedia()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUpload(_ image: UIImage,
                          to path: String,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkMedia?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOMedia()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUpload(_ pdfDocument: PDFDocument,
                          to path: String,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkMedia?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOMedia()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUpload(_ text: String,
                          to path: String,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkMedia?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOMedia()))
        _ = resultBlock?(.completed)
    }
}
