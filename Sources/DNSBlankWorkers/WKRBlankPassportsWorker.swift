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
    public required init(call callNextWhen: PTCLCallNextWhen,
                         nextWorker: PTCLPassports_Protocol) {
        super.init()
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

    // MARK: - Business Logic / Single Item CRUD

    open func doLoadPassport(of passportType: PTCLPassportsProtocolPassportTypes,
                             for account: DAOAccount,
                             with progress: PTCLProgressBlock?) -> AnyPublisher<Data, Error> {
        return try! self.runDo {
            guard let nextWorker = self.nextWorker else {
                return Future<Data, Error> { $0(.success(Data())) }.eraseToAnyPublisher()
            }
            return nextWorker.doLoadPassport(of: passportType, for: account, with: progress)
        } as! AnyPublisher<Data, Error>
    }
}
