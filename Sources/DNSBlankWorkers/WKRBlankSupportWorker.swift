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
    public var nextWorker: PTCLSupport_Protocol?

    public required init() {
        super.init()
    }
    public required init(nextWorker: PTCLSupport_Protocol) {
        super.init()
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

    // MARK: - Business Logic / Single Item CRUD

    open func doGetUpdatedCount(with progress: PTCLProgressBlock?) -> AnyPublisher<Int, Error> {
        guard let nextWorker = self.nextWorker else {
            return Future<Int, Error> { $0(.success(0)) }.eraseToAnyPublisher()
        }
        return nextWorker.doGetUpdatedCount(with: progress)
    }
    open func doPrepare(attachment image: UIImage,
                        with progress: PTCLProgressBlock?) -> AnyPublisher<PTCLSupportAttachment, Error> {
        guard let nextWorker = self.nextWorker else {
            return Future<PTCLSupportAttachment, Error> {
                $0(.success(PTCLSupportAttachment(image: image)))
            }.eraseToAnyPublisher()
        }
        return nextWorker.doPrepare(attachment: image, with: progress)
    }
    open func doSendRequest(subject: String,
                            body: String,
                            tags: [String],
                            attachments: [PTCLSupportAttachment],
                            properties: [String: String],
                            with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error> {
        guard let nextWorker = self.nextWorker else {
            return Future<Bool, Error> {
                $0(.success(true))
            }.eraseToAnyPublisher()
        }
        return nextWorker.doSendRequest(subject: subject, body: body, tags: tags,
                                        attachments: attachments, properties: properties,
                                        with: progress)
    }
}
