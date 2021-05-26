//
//  WKRBlankValidationWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import DNSProtocols
import Foundation

open class WKRBlankValidationWorker: WKRBlankBaseWorker, PTCLValidation_Protocol
{
    public var callNextWhen: PTCLCallNextWhen = .whenUnhandled
    public var nextWorker: PTCLValidation_Protocol?

    public required init() {
        super.init()
    }
    public required init(call callNextWhen: PTCLCallNextWhen,
                         nextWorker: PTCLValidation_Protocol) {
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

    open func doValidateBirthdate(for birthdate: Date?,
                                  with config: PTCLValidationBirthdateConfig) throws -> DNSError? {
        return try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateBirthdate(for: birthdate, with: config)
        } as! DNSError?
    }
    open func doValidateDate(for date: Date?,
                             with config: PTCLValidationDateConfig) throws -> DNSError? {
        return try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateDate(for: date, with: config)
        } as! DNSError?
    }
    open func doValidateEmail(for email: String?,
                              with config: PTCLValidationEmailConfig) throws -> DNSError? {
        return try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateEmail(for: email, with: config)
        } as! DNSError?
    }
    open func doValidateHandle(for handle: String?,
                               with config: PTCLValidationHandleConfig) throws -> DNSError? {
        return try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateHandle(for: handle, with: config)
        } as! DNSError?
    }
    open func doValidateName(for name: String?,
                             with config: PTCLValidationNameConfig) throws -> DNSError? {
        return try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateName(for: name, with: config)
        } as! DNSError?
    }
    open func doValidateNumber(for number: String?,
                               with config: PTCLValidationNumberConfig) throws -> DNSError? {
        return try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateNumber(for: number, with: config)
        } as! DNSError?
    }
    open func doValidatePassword(for password: String?,
                                 with config: PTCLValidationPasswordConfig) throws -> DNSError? {
        return try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidatePassword(for: password, with: config)
        } as! DNSError?
    }
    open func doValidatePercentage(for percentage: String?,
                                   with config: PTCLValidationPercentageConfig) throws -> DNSError? {
        return try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidatePercentage(for: percentage, with: config)
        } as! DNSError?
    }
    open func doValidatePhone(for phone: String?,
                              with config: PTCLValidationPhoneConfig) throws -> DNSError? {
        return try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidatePhone(for: phone, with: config)
        } as! DNSError?
    }
    open func doValidateSearch(for search: String?,
                               with config: PTCLValidationSearchConfig) throws -> DNSError? {
        return try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateSearch(for: search, with: config)
        } as! DNSError?
    }
    open func doValidateState(for state: String?,
                              with config: PTCLValidationStateConfig) throws -> DNSError? {
        return try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateState(for: state, with: config)
        } as! DNSError?
    }
    open func doValidateUnsignedNumber(for number: String?,
                                       with config: PTCLValidationUnsignedNumberConfig) throws -> DNSError? {
        return try self.runDo {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateUnsignedNumber(for: number, with: config)
        } as! DNSError?
    }
}
