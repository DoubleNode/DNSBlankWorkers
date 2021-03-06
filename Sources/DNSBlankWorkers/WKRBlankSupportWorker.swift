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

open class WKRBlankSupportWorker: WKRBlankBaseWorker, PTCLSupport_Protocol
{
    public var callNextWhen: PTCLCallNextWhen = .whenUnhandled
    public var nextWorker: PTCLSupport_Protocol?

    public required init() {
        super.init()
    }
    public func register(nextWorker: PTCLSupport_Protocol,
                         for callNextWhen: PTCLCallNextWhen) {
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
    public func runDo(runNext: PTCLCallBlock?,
                      doWork: PTCLCallResultBlockThrows = { return $0?(.unhandled) }) throws -> Any? {
        return try self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }

    // MARK: - Protocol Interface Methods
    public func doGetUpdatedCount(with progress: PTCLProgressBlock?) -> AnyPublisher<Int, Error> {
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
                          with progress: PTCLProgressBlock?) -> AnyPublisher<PTCLSupportAttachment, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<PTCLSupportAttachment, Error> {
                    $0(.success(PTCLSupportAttachment(image: image)))
                }.eraseToAnyPublisher()
            }
            return nextWorker.doPrepare(attachment: image, with: progress)
        },
        doWork: {
            return self.intDoPrepare(attachment: image, with: progress, then: $0)
        }) as! AnyPublisher<PTCLSupportAttachment, Error>
    }
    public func doSendRequest(subject: String,
                              body: String,
                              tags: [String],
                              attachments: [PTCLSupportAttachment],
                              properties: [String: String],
                              with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
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

    // MARK: - Internal Work Methods
    open func intDoGetUpdatedCount(with progress: PTCLProgressBlock?,
                                   then resultBlock: PTCLResultBlock?) -> AnyPublisher<Int, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Int, Error>
    }
    open func intDoPrepare(attachment image: UIImage,
                           with progress: PTCLProgressBlock?,
                           then resultBlock: PTCLResultBlock?) -> AnyPublisher<PTCLSupportAttachment, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<PTCLSupportAttachment, Error>
    }
    open func intDoSendRequest(subject: String,
                               body: String,
                               tags: [String],
                               attachments: [PTCLSupportAttachment],
                               properties: [String: String],
                               with progress: PTCLProgressBlock?,
                               then resultBlock: PTCLResultBlock?) -> AnyPublisher<Bool, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Bool, Error>
    }
}
