//
//  WKRBlankMedia.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSError
import DNSProtocols
import PDFKit
import UIKit

open class WKRBlankMedia: WKRBlankBase, WKRPTCLMedia {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLMedia?

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLMedia,
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
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Media.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doRemove(_ media: DAOMedia,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLMediaBlkVoid?) {
        self.runDo(runNext: {
            return self.nextWorker?.doRemove(media, with: progress, and: block)
        },
        doWork: {
            return self.intDoRemove(media, with: progress, and: block, then: $0)
        })
    }
    public func doUpload(from fileUrl: URL,
                         to path: String,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLMediaBlkMedia?) {
        self.runDo(runNext: {
            return self.nextWorker?.doUpload(from: fileUrl, to: path, with: progress, and: block)
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
            return self.nextWorker?.doUpload(image, to: path, with: progress, and: block)
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
            return self.nextWorker?.doUpload(pdfDocument, to: path, with: progress, and: block)
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
            return self.nextWorker?.doUpload(text, to: path, with: progress, and: block)
        },
        doWork: {
            return self.intDoUpload(text, to: path, with: progress, and: block, then: $0)
        })
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doRemove(_ media: DAOMedia,
                         with block: WKRPTCLMediaBlkVoid?) {
        self.doRemove(media, with: nil, and: block)
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
    open func intDoRemove(_ media: DAOMedia,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpload(from fileUrl: URL,
                          to path: String,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkMedia?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpload(_ image: UIImage,
                          to path: String,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkMedia?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpload(_ pdfDocument: PDFDocument,
                          to path: String,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkMedia?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoUpload(_ text: String,
                          to path: String,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLMediaBlkMedia?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
