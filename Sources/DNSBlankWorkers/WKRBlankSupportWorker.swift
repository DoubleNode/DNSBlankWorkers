//
//  WKRBlankSupportWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
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
                      doWork: DNSPTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Worker Logic (Public) -
    public func doGetUpdatedCount(with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Int, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Int, Error> { $0(.success(0)) }.eraseToAnyPublisher()
            }
            return nextWorker.doGetUpdatedCount(with: progress)
        },
        doWork: {
            return self.intDoGetUpdatedCount(with: progress, then: $0)
        }) as! AnyPublisher<Int, Error>
    }
    public func doPrepare(attachment image: UIImage,
                          with progress: DNSPTCLProgressBlock?) -> AnyPublisher<WKRPTCLSupportAttachment, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<WKRPTCLSupportAttachment, Error> {
                    $0(.success(WKRPTCLSupportAttachment(image: image)))
                }.eraseToAnyPublisher()
            }
            return nextWorker.doPrepare(attachment: image, with: progress)
        },
        doWork: {
            return self.intDoPrepare(attachment: image, with: progress, then: $0)
        }) as! AnyPublisher<WKRPTCLSupportAttachment, Error>
    }
    public func doSendRequest(subject: String,
                              body: String,
                              tags: [String],
                              attachments: [WKRPTCLSupportAttachment],
                              properties: [String: String],
                              with progress: DNSPTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Bool, Error> { $0(.success(true)) }.eraseToAnyPublisher()
            }
            return nextWorker.doSendRequest(subject: subject, body: body, tags: tags,
                                            attachments: attachments, properties: properties,
                                            with: progress)
        },
        doWork: {
            return self.intDoSendRequest(subject: subject, body: body, tags: tags,
                                         attachments: attachments, properties: properties,
                                         with: progress, then: $0)
        }) as! AnyPublisher<Bool, Error>
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doGetUpdatedCount() -> AnyPublisher<Int, Error> {
        return self.doGetUpdatedCount(with: nil)
    }
    public func doPrepare(attachment image: UIImage) -> AnyPublisher<WKRPTCLSupportAttachment, Error> {
        return self.doPrepare(attachment: image, with: nil)
    }
    public func doSendRequest(subject: String,
                              body: String,
                              tags: [String],
                              attachments: [WKRPTCLSupportAttachment],
                              properties: [String: String]) -> AnyPublisher<Bool, Error> {
        return self.doSendRequest(subject: subject, body: body, tags: tags,
                                  attachments: attachments, properties: properties,
                                  with: nil)
    }

    // MARK: - Internal Work Methods
    open func intDoGetUpdatedCount(with progress: DNSPTCLProgressBlock?,
                                   then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<Int, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Int, Error>
    }
    open func intDoPrepare(attachment image: UIImage,
                           with progress: DNSPTCLProgressBlock?,
                           then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<WKRPTCLSupportAttachment, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<WKRPTCLSupportAttachment, Error>
    }
    open func intDoSendRequest(subject: String,
                               body: String,
                               tags: [String],
                               attachments: [WKRPTCLSupportAttachment],
                               properties: [String: String],
                               with progress: DNSPTCLProgressBlock?,
                               then resultBlock: DNSPTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
}
