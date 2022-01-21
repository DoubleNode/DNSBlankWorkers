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

open class WKRBlankValidationWorker: WKRBlankBaseWorker, PTCLValidation
{
    public var callNextWhen: PTCLProtocol.Call.NextWhen = .whenUnhandled
    public var nextWorker: PTCLValidation?
    public var systemsStateWorker: PTCLSystemsState? = WKRBlankSystemsStateWorker()

    public required init() {
        super.init()
    }
    public func register(nextWorker: PTCLValidation,
                         for callNextWhen: PTCLProtocol.Call.NextWhen) {
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
                                    with config: PTCLValidation.Data.Config.Birthdate) throws -> DNSError.Validation? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateBirthdate(for: birthdate, with: config)
        },
        doWork: {
            return try self.intDoValidateBirthdate(for: birthdate, with: config, then: $0)
        }) as! DNSError.Validation?
    }
    public func doValidateCalendarDate(for date: Date?,
                                       with config: PTCLValidation.Data.Config.CalendarDate) throws -> DNSError.Validation? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateCalendarDate(for: date, with: config)
        },
        doWork: {
            return try self.intDoValidateCalendarDate(for: date, with: config, then: $0)
        }) as! DNSError.Validation?
    }
    public func doValidateEmail(for email: String?,
                                with config: PTCLValidation.Data.Config.Email) throws -> DNSError.Validation? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateEmail(for: email, with: config)
        },
        doWork: {
            return try self.intDoValidateEmail(for: email, with: config, then: $0)
        }) as! DNSError.Validation?
    }
    public func doValidateHandle(for handle: String?,
                                 with config: PTCLValidation.Data.Config.Handle) throws -> DNSError.Validation? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateHandle(for: handle, with: config)
        },
        doWork: {
            return try self.intDoValidateHandle(for: handle, with: config, then: $0)
        }) as! DNSError.Validation?
    }
    public func doValidateName(for name: String?,
                               with config: PTCLValidation.Data.Config.Name) throws -> DNSError.Validation? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateName(for: name, with: config)
        },
        doWork: {
            return try self.intDoValidateName(for: name, with: config, then: $0)
        }) as! DNSError.Validation?
    }
    public func doValidateNumber(for number: String?,
                                 with config: PTCLValidation.Data.Config.Number) throws -> DNSError.Validation? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateNumber(for: number, with: config)
        },
        doWork: {
            return try self.intDoValidateNumber(for: number, with: config, then: $0)
        }) as! DNSError.Validation?
    }
    public func doValidatePassword(for password: String?,
                                   with config: PTCLValidation.Data.Config.Password) throws -> DNSError.Validation? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidatePassword(for: password, with: config)
        },
        doWork: {
            return try self.intDoValidatePassword(for: password, with: config, then: $0)
        }) as! DNSError.Validation?
    }
    public func doValidatePercentage(for percentage: String?,
                                     with config: PTCLValidation.Data.Config.Percentage) throws -> DNSError.Validation? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidatePercentage(for: percentage, with: config)
        },
        doWork: {
            return try self.intDoValidatePercentage(for: percentage, with: config, then: $0)
        }) as! DNSError.Validation?
    }
    public func doValidatePhone(for phone: String?,
                                with config: PTCLValidation.Data.Config.Phone) throws -> DNSError.Validation? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidatePhone(for: phone, with: config)
        },
        doWork: {
            return try self.intDoValidatePhone(for: phone, with: config, then: $0)
        }) as! DNSError.Validation?
    }
    public func doValidateSearch(for search: String?,
                                 with config: PTCLValidation.Data.Config.Search) throws -> DNSError.Validation? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateSearch(for: search, with: config)
        },
        doWork: {
            return try self.intDoValidateSearch(for: search, with: config, then: $0)
        }) as! DNSError.Validation?
    }
    public func doValidateState(for state: String?,
                                with config: PTCLValidation.Data.Config.State) throws -> DNSError.Validation? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateState(for: state, with: config)
        },
        doWork: {
            return try self.intDoValidateState(for: state, with: config, then: $0)
        }) as! DNSError.Validation?
    }
    public func doValidateUnsignedNumber(for number: String?,
                                         with config: PTCLValidation.Data.Config.UnsignedNumber) throws -> DNSError.Validation? {
        return try self.runDo(runNext: {
            guard let nextWorker = self.nextWorker else { return nil }
            return try nextWorker.doValidateUnsignedNumber(for: number, with: config)
        },
        doWork: {
            return try self.intDoValidateUnsignedNumber(for: number, with: config, then: $0)
        }) as! DNSError.Validation?
    }

    // MARK: - Internal Work Methods
    open func intDoValidateBirthdate(for birthdate: Date?,
                                     with config: PTCLValidation.Data.Config.Birthdate,
                                     then resultBlock: PTCLResultBlock?) throws -> DNSError.Validation? {
        return resultBlock?(.unhandled) as! DNSError.Validation?
    }
    open func intDoValidateCalendarDate(for date: Date?,
                                        with config: PTCLValidation.Data.Config.CalendarDate,
                                        then resultBlock: PTCLResultBlock?) throws -> DNSError.Validation? {
        return resultBlock?(.unhandled) as! DNSError.Validation?
    }
    open func intDoValidateEmail(for email: String?,
                                 with config: PTCLValidation.Data.Config.Email,
                                 then resultBlock: PTCLResultBlock?) throws -> DNSError.Validation? {
        return resultBlock?(.unhandled) as! DNSError.Validation?
    }
    open func intDoValidateHandle(for handle: String?,
                                  with config: PTCLValidation.Data.Config.Handle,
                                  then resultBlock: PTCLResultBlock?) throws -> DNSError.Validation? {
        return resultBlock?(.unhandled) as! DNSError.Validation?
    }
    open func intDoValidateName(for name: String?,
                                with config: PTCLValidation.Data.Config.Name,
                                then resultBlock: PTCLResultBlock?) throws -> DNSError.Validation? {
        return resultBlock?(.unhandled) as! DNSError.Validation?
    }
    open func intDoValidateNumber(for number: String?,
                                  with config: PTCLValidation.Data.Config.Number,
                                  then resultBlock: PTCLResultBlock?) throws -> DNSError.Validation? {
        return resultBlock?(.unhandled) as! DNSError.Validation?
    }
    open func intDoValidatePassword(for password: String?,
                                    with config: PTCLValidation.Data.Config.Password,
                                    then resultBlock: PTCLResultBlock?) throws -> DNSError.Validation? {
        return resultBlock?(.unhandled) as! DNSError.Validation?
    }
    open func intDoValidatePercentage(for percentage: String?,
                                      with config: PTCLValidation.Data.Config.Percentage,
                                      then resultBlock: PTCLResultBlock?) throws -> DNSError.Validation? {
        return resultBlock?(.unhandled) as! DNSError.Validation?
    }
    open func intDoValidatePhone(for phone: String?,
                                 with config: PTCLValidation.Data.Config.Phone,
                                 then resultBlock: PTCLResultBlock?) throws -> DNSError.Validation? {
        return resultBlock?(.unhandled) as! DNSError.Validation?
    }
    open func intDoValidateSearch(for search: String?,
                                  with config: PTCLValidation.Data.Config.Search,
                                  then resultBlock: PTCLResultBlock?) throws -> DNSError.Validation? {
        return resultBlock?(.unhandled) as! DNSError.Validation?
    }
    open func intDoValidateState(for state: String?,
                                 with config: PTCLValidation.Data.Config.State,
                                 then resultBlock: PTCLResultBlock?) throws -> DNSError.Validation? {
        return resultBlock?(.unhandled) as! DNSError.Validation?
    }
    open func intDoValidateUnsignedNumber(for number: String?,
                                          with config: PTCLValidation.Data.Config.UnsignedNumber,
                                          then resultBlock: PTCLResultBlock?) throws -> DNSError.Validation? {
        return resultBlock?(.unhandled) as! DNSError.Validation?
    }
}
