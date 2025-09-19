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

open class WKRBlankMedia: WKRBlankBase, WKRPTCLMedia {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled

    public var nextWKRPTCLMedia: WKRPTCLMedia? {
        get { return nextWorker as? WKRPTCLMedia }
        set { nextWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLMedia,
                         for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.callNextWhen = callNextWhen
        self.nextWKRPTCLMedia = nextWorker
    }

    override open func disableOption(_ option: String) {
        super.disableOption(option)
        nextWKRPTCLMedia?.disableOption(option)
    }
    override open func enableOption(_ option: String) {
        super.enableOption(option)
        nextWKRPTCLMedia?.enableOption(option)
    }
    @discardableResult
    public func runDo(runNext: DNSPTCLCallBlock?,
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWKRPTCLMedia != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Media.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doReact(with reaction: DNSReactionType,
                        to media: DAOMedia,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLMediaBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLMedia?.doReact(with: reaction, to: media, with: progress, and: block)
        },
                   doWork: {
            return self.intDoReact(with: reaction, to: media, with: progress, and: block, then: $0)
        })
    }
    public func doRemove(_ media: DAOMedia,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLMediaBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLMedia?.doRemove(media, with: progress, and: block)
        },
                   doWork: {
            return self.intDoRemove(media, with: progress, and: block, then: $0)
        })
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to media: DAOMedia,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkMeta?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLMedia?.doUnreact(with: reaction, to: media, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUnreact(with: reaction, to: media, with: progress, and: block, then: $0)
        })
    }
    public func doUpload(from fileUrl: URL,
                         to path: String,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLMediaBlkMedia?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLMedia?.doUpload(from: fileUrl, to: path, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpload(from: fileUrl, to: path, with: progress, and: block, then: $0)
        })
    }
    public func doUpload(_ image: UIImage,
                         to path: String,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLMediaBlkMedia?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLMedia?.doUpload(image, to: path, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpload(image, to: path, with: progress, and: block, then: $0)
        })
    }
    public func doUpload(_ pdfDocument: PDFDocument,
                         to path: String,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLMediaBlkMedia?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLMedia?.doUpload(pdfDocument, to: path, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpload(pdfDocument, to: path, with: progress, and: block, then: $0)
        })
    }
    public func doUpload(_ text: String,
                         to path: String,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLMediaBlkMedia?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLMedia?.doUpload(text, to: path, with: progress, and: block)
        },
                   doWork: {
            return self.intDoUpload(text, to: path, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doReact(with reaction: DNSReactionType,
                        to media: DAOMedia,
                        with block: WKRPTCLMediaBlkMeta?) {
        self.doReact(with: reaction, to: media, with: nil, and: block)
    }
    public func doRemove(_ media: DAOMedia,
                         with block: WKRPTCLMediaBlkVoid?) {
        self.doRemove(media, with: nil, and: block)
    }
    public func doUnreact(with reaction: DNSReactionType,
                          to media: DAOMedia,
                          with block: WKRPTCLMediaBlkMeta?) {
        self.doUnreact(with: reaction, to: media, with: nil, and: block)
    }
    public func doUpload(from fileUrl: URL,
                         to path: String,
                         with block: WKRPTCLMediaBlkMedia?) {
        self.doUpload(from: fileUrl, to: path, with: nil, and: block)
    }
    public func doUpload(_ image: UIImage,
                         to path: String,
                         with block: WKRPTCLMediaBlkMedia?) {
        self.doUpload(image, to: path, with: nil, and: block)
    }
    public func doUpload(_ pdfDocument: PDFDocument,
                         to path: String,
                         with block: WKRPTCLMediaBlkMedia?) {
        self.doUpload(pdfDocument, to: path, with: nil, and: block)
    }
    public func doUpload(_ text: String,
                         to path: String,
                         with block: WKRPTCLMediaBlkMedia?) {
        self.doUpload(text, to: path, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoReact(with reaction: DNSReactionType,
                         to media: DAOMedia,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLMediaBlkMeta?,
                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    open func intDoRemove(_ media: DAOMedia,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    open func intDoUnreact(with reaction: DNSReactionType,
                           to media: DAOMedia,
                           with progress: DNSPTCLProgressBlock?,
                           and block: WKRPTCLMediaBlkMeta?,
                           then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    open func intDoUpload(from fileUrl: URL,
                          to path: String,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkMedia?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOMedia()))
        _ = resultBlock?(.completed)
    }
    open func intDoUpload(_ image: UIImage,
                          to path: String,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkMedia?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOMedia()))
        _ = resultBlock?(.completed)
    }
    open func intDoUpload(_ pdfDocument: PDFDocument,
                          to path: String,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkMedia?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOMedia()))
        _ = resultBlock?(.completed)
    }
    open func intDoUpload(_ text: String,
                          to path: String,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkMedia?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOMedia()))
        _ = resultBlock?(.completed)
    }
}
