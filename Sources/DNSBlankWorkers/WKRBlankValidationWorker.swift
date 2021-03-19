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
    public var nextWorker: PTCLValidation_Protocol?

    public var minimumBirthdateAge: Int32 = -1
    public var maximumBirthdateAge: Int32 = -1

    public var minimumHandleLength: Int32 = -1
    public var maximumHandleLength: Int32 = -1

    public var minimumNameLength: Int32 = -1
    public var maximumNameLength: Int32 = -1

    public var minimumNumberValue: Int64 = -1
    public var maximumNumberValue: Int64 = -1

    public var minimumPercentageValue: Float = -1
    public var maximumPercentageValue: Float = -1

    public var minimumPhoneLength: Int32 = -1
    public var maximumPhoneLength: Int32 = -1

    public var minimumUnsignedNumberValue: Int64 = -1
    public var maximumUnsignedNumberValue: Int64 = -1

    public var requiredPasswordStrength: PTCLPasswordStrengthType = .strong

    public required init() {
        super.init()
    }

    public required init(nextWorker: PTCLValidation_Protocol) {
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

    open func doValidateBirthdate(for birthdate: Date) throws -> DNSError? {
        guard nextWorker != nil else { return nil }
        return try nextWorker!.doValidateBirthdate(for: birthdate)
    }

    open func doValidateEmail(for email: String) throws -> DNSError? {
        guard nextWorker != nil else { return nil }
        return try nextWorker!.doValidateEmail(for: email)
    }

    open func doValidateHandle(for handle: String) throws -> DNSError? {
        guard nextWorker != nil else { return nil }
        return try nextWorker!.doValidateHandle(for: handle)
    }

    open func doValidateName(for name: String) throws -> DNSError? {
        guard nextWorker != nil else { return nil }
        return try nextWorker!.doValidateName(for: name)
    }
    
    open func doValidateNumber(for number: String) throws -> DNSError? {
        guard nextWorker != nil else { return nil }
        return try nextWorker!.doValidateNumber(for: number)
    }
                                      
    open func doValidatePassword(for password: String) throws -> DNSError? {
        guard nextWorker != nil else { return nil }
        return try nextWorker!.doValidatePassword(for: password)
    }

    open func doValidatePercentage(for percentage: String) throws -> DNSError? {
        guard nextWorker != nil else { return nil }
        return try nextWorker!.doValidatePercentage(for: percentage)
    }

    open func doValidatePhone(for phone: String) throws -> DNSError? {
        guard nextWorker != nil else { return nil }
        return try nextWorker!.doValidatePhone(for: phone)
    }

    open func doValidateSearch(for search: String) throws -> DNSError? {
        guard nextWorker != nil else { return nil }
        return try nextWorker!.doValidateSearch(for: search)
    }

    open func doValidateState(for state: String) throws -> DNSError? {
        guard nextWorker != nil else { return nil }
        return try nextWorker!.doValidateState(for: state)
    }

    open func doValidateUnsignedNumber(for number: String) throws -> DNSError? {
        guard nextWorker != nil else { return nil }
        return try nextWorker!.doValidateUnsignedNumber(for: number)
    }
}
