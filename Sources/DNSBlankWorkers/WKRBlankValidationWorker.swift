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
    public func register(nextWorker: PTCLValidation_Protocol,
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
    public func doValidateBirthdate(for birthdate: Date?,
                                    with config: PTCLValidationBirthdateConfig) throws -> DNSError? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateBirthdate(for: birthdate, with: config)
        },
        doWork: {
            return try self.intDoValidateBirthdate(for: birthdate, with: config, then: $0)
        }) as! DNSError?
    }
    public func doValidateDate(for date: Date?,
                               with config: PTCLValidationDateConfig) throws -> DNSError? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateDate(for: date, with: config)
        },
        doWork: {
            return try self.intDoValidateDate(for: date, with: config, then: $0)
        }) as! DNSError?
    }
    public func doValidateEmail(for email: String?,
                                with config: PTCLValidationEmailConfig) throws -> DNSError? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateEmail(for: email, with: config)
        },
        doWork: {
            return try self.intDoValidateEmail(for: email, with: config, then: $0)
        }) as! DNSError?
    }
    public func doValidateHandle(for handle: String?,
                                 with config: PTCLValidationHandleConfig) throws -> DNSError? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateHandle(for: handle, with: config)
        },
        doWork: {
            return try self.intDoValidateHandle(for: handle, with: config, then: $0)
        }) as! DNSError?
    }
    public func doValidateName(for name: String?,
                               with config: PTCLValidationNameConfig) throws -> DNSError? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateName(for: name, with: config)
        },
        doWork: {
            return try self.intDoValidateName(for: name, with: config, then: $0)
        }) as! DNSError?
    }
    public func doValidateNumber(for number: String?,
                                 with config: PTCLValidationNumberConfig) throws -> DNSError? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateNumber(for: number, with: config)
        },
        doWork: {
            return try self.intDoValidateNumber(for: number, with: config, then: $0)
        }) as! DNSError?
    }
    public func doValidatePassword(for password: String?,
                                   with config: PTCLValidationPasswordConfig) throws -> DNSError? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidatePassword(for: password, with: config)
        },
        doWork: {
            return try self.intDoValidatePassword(for: password, with: config, then: $0)
        }) as! DNSError?
    }
    public func doValidatePercentage(for percentage: String?,
                                     with config: PTCLValidationPercentageConfig) throws -> DNSError? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidatePercentage(for: percentage, with: config)
        },
        doWork: {
            return try self.intDoValidatePercentage(for: percentage, with: config, then: $0)
        }) as! DNSError?
    }
    public func doValidatePhone(for phone: String?,
                                with config: PTCLValidationPhoneConfig) throws -> DNSError? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidatePhone(for: phone, with: config)
        },
        doWork: {
            return try self.intDoValidatePhone(for: phone, with: config, then: $0)
        }) as! DNSError?
    }
    public func doValidateSearch(for search: String?,
                                 with config: PTCLValidationSearchConfig) throws -> DNSError? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateSearch(for: search, with: config)
        },
        doWork: {
            return try self.intDoValidateSearch(for: search, with: config, then: $0)
        }) as! DNSError?
    }
    public func doValidateState(for state: String?,
                                with config: PTCLValidationStateConfig) throws -> DNSError? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateState(for: state, with: config)
        },
        doWork: {
            return try self.intDoValidateState(for: state, with: config, then: $0)
        }) as! DNSError?
    }
    public func doValidateUnsignedNumber(for number: String?,
                                         with config: PTCLValidationUnsignedNumberConfig) throws -> DNSError? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateUnsignedNumber(for: number, with: config)
        },
        doWork: {
            return try self.intDoValidateUnsignedNumber(for: number, with: config, then: $0)
        }) as! DNSError?
    }

    // MARK: - Internal Work Methods
    open func intDoValidateBirthdate(for birthdate: Date?,
                                     with config: PTCLValidationBirthdateConfig,
                                     then resultBlock: PTCLResultBlock?) throws -> DNSError? {
        return resultBlock?(.unhandled) as! DNSError?
    }
    open func intDoValidateDate(for date: Date?,
                                with config: PTCLValidationDateConfig,
                                then resultBlock: PTCLResultBlock?) throws -> DNSError? {
        return resultBlock?(.unhandled) as! DNSError?
    }
    open func intDoValidateEmail(for email: String?,
                                 with config: PTCLValidationEmailConfig,
                                 then resultBlock: PTCLResultBlock?) throws -> DNSError? {
        return resultBlock?(.unhandled) as! DNSError?
    }
    open func intDoValidateHandle(for handle: String?,
                                  with config: PTCLValidationHandleConfig,
                                  then resultBlock: PTCLResultBlock?) throws -> DNSError? {
        return resultBlock?(.unhandled) as! DNSError?
    }
    open func intDoValidateName(for name: String?,
                                with config: PTCLValidationNameConfig,
                                then resultBlock: PTCLResultBlock?) throws -> DNSError? {
        return resultBlock?(.unhandled) as! DNSError?
    }
    open func intDoValidateNumber(for number: String?,
                                  with config: PTCLValidationNumberConfig,
                                  then resultBlock: PTCLResultBlock?) throws -> DNSError? {
        return resultBlock?(.unhandled) as! DNSError?
    }
    open func intDoValidatePassword(for password: String?,
                                    with config: PTCLValidationPasswordConfig,
                                    then resultBlock: PTCLResultBlock?) throws -> DNSError? {
        return resultBlock?(.unhandled) as! DNSError?
    }
    open func intDoValidatePercentage(for percentage: String?,
                                      with config: PTCLValidationPercentageConfig,
                                      then resultBlock: PTCLResultBlock?) throws -> DNSError? {
        return resultBlock?(.unhandled) as! DNSError?
    }
    open func intDoValidatePhone(for phone: String?,
                                 with config: PTCLValidationPhoneConfig,
                                 then resultBlock: PTCLResultBlock?) throws -> DNSError? {
        return resultBlock?(.unhandled) as! DNSError?
    }
    open func intDoValidateSearch(for search: String?,
                                  with config: PTCLValidationSearchConfig,
                                  then resultBlock: PTCLResultBlock?) throws -> DNSError? {
        return resultBlock?(.unhandled) as! DNSError?
    }
    open func intDoValidateState(for state: String?,
                                 with config: PTCLValidationStateConfig,
                                 then resultBlock: PTCLResultBlock?) throws -> DNSError? {
        return resultBlock?(.unhandled) as! DNSError?
    }
    open func intDoValidateUnsignedNumber(for number: String?,
                                          with config: PTCLValidationUnsignedNumberConfig,
                                          then resultBlock: PTCLResultBlock?) throws -> DNSError? {
        return resultBlock?(.unhandled) as! DNSError?
    }
}
