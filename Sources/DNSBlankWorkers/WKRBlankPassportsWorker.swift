//
//  WKRBlankPassportsWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSDataObjects
import DNSProtocols
import Foundation

open class WKRBlankPassportsWorker: WKRBlankBaseWorker, PTCLPassports_Protocol
{
    public var callNextWhen: PTCLCallNextWhen = .whenUnhandled
    public var nextWorker: PTCLPassports_Protocol?

    public required init() {
        super.init()
    }
    public func register(nextWorker: PTCLPassports_Protocol,
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
    public func doLoadPassport(of passportType: PTCLPassportsProtocolPassportTypes,
                               for account: DAOAccount,
                               with progress: PTCLProgressBlock?) -> AnyPublisher<Data, Error> {
        return try! self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else {
                return Future<Data, Error> { $0(.success(Data())) }.eraseToAnyPublisher()
            }
            return nextWorker.doLoadPassport(of: passportType, for: account, with: progress)
        },
        doWork: {
            return self.intDoLoadPassport(of: passportType, for: account, with: progress, then: $0)
        }) as! AnyPublisher<Data, Error>
    }

    // MARK: - Internal Work Methods
    open func intDoLoadPassport(of passportType: PTCLPassportsProtocolPassportTypes,
                                for account: DAOAccount,
                                with progress: PTCLProgressBlock?,
                                then resultBlock: PTCLResultBlock?) -> AnyPublisher<Data, Error> {
        return resultBlock?(.unhandled) as! AnyPublisher<Data, Error>
    }
}
