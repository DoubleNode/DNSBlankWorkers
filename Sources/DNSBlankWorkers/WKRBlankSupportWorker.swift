//
//  WKRBlankSupportWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSError
import DNSProtocols
import UIKit

open class WKRBlankSupportWorker: WKRBlankBaseWorker, WKRPTCLSupport {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLSupport?

    public required init() {
        super.init()
    }
    public func register(nextWorker: WKRPTCLSupport,
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
        if case DNSError.Support.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doGetUpdatedCount(with progress: DNSPTCLProgressBlock?) -> WKRPTCLSupportPubInt {
        return  self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLSupportFutInt { $0(.success(0)) }.eraseToAnyPublisher()
            }
            return nextWorker.doGetUpdatedCount(with: progress)
        },
                                  doWork: {
            return self.intDoGetUpdatedCount(with: progress, then: $0)
        }) as! WKRPTCLSupportPubInt // swiftlint:disable:this force_cast
    }
    public func doPrepare(attachment image: UIImage,
                          with progress: DNSPTCLProgressBlock?) -> WKRPTCLSupportPubAttach {
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLSupportFutAttach {
                    $0(.success(WKRPTCLSupportAttachment(image: image)))
                }.eraseToAnyPublisher()
            }
            return nextWorker.doPrepare(attachment: image, with: progress)
        },
                                  doWork: {
            return self.intDoPrepare(attachment: image, with: progress, then: $0)
        }) as! WKRPTCLSupportPubAttach // swiftlint:disable:this force_cast
    }
    public func doSendRequest(subject: String,
                              body: String,
                              tags: [String],
                              attachments: [WKRPTCLSupportAttachment],
                              properties: [String: String],
                              with progress: DNSPTCLProgressBlock?) -> WKRPTCLSupportPubVoid {
        return self.runDoPub(runNext: {
            guard let nextWorker = self.nextWorker else {
                return WKRPTCLSupportFutVoid { $0(.success) }.eraseToAnyPublisher()
            }
            return nextWorker.doSendRequest(subject: subject, body: body, tags: tags,
                                            attachments: attachments, properties: properties,
                                            with: progress)
        },
                                  doWork: {
            return self.intDoSendRequest(subject: subject, body: body, tags: tags,
                                         attachments: attachments, properties: properties,
                                         with: progress, then: $0)
        }) as! WKRPTCLSupportPubVoid // swiftlint:disable:this force_cast
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doGetUpdatedCount() -> WKRPTCLSupportPubInt {
        return self.doGetUpdatedCount(with: nil)
    }
    public func doPrepare(attachment image: UIImage) -> WKRPTCLSupportPubAttach {
        return self.doPrepare(attachment: image, with: nil)
    }
    public func doSendRequest(subject: String,
                              body: String,
                              tags: [String],
                              attachments: [WKRPTCLSupportAttachment],
                              properties: [String: String]) -> WKRPTCLSupportPubVoid {
        return self.doSendRequest(subject: subject, body: body, tags: tags,
                                  attachments: attachments, properties: properties,
                                  with: nil)
    }

    // MARK: - Internal Work Methods
    open func intDoGetUpdatedCount(with progress: DNSPTCLProgressBlock?,
                                   then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLSupportPubInt {
        return resultBlock?(.unhandled) as! WKRPTCLSupportPubInt // swiftlint:disable:this force_cast
    }
    open func intDoPrepare(attachment image: UIImage,
                           with progress: DNSPTCLProgressBlock?,
                           then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLSupportPubAttach {
        return resultBlock?(.unhandled) as! WKRPTCLSupportPubAttach // swiftlint:disable:this force_cast
    }
    open func intDoSendRequest(subject: String,
                               body: String,
                               tags: [String],
                               attachments: [WKRPTCLSupportAttachment],
                               properties: [String: String],
                               with progress: DNSPTCLProgressBlock?,
                               then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLSupportPubVoid {
        return resultBlock?(.unhandled) as! WKRPTCLSupportPubVoid // swiftlint:disable:this force_cast
    }
}
