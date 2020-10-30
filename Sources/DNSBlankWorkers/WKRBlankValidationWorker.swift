//
//  WKRBlankValidationWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

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

    open func doValidateBirthdate(for birthdate: Date,
                                  with progress: PTCLProgressBlock?,
                                  and block: PTCLValidationBlockVoidBoolDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doValidateBirthdate(for: birthdate, with: progress, and: block)
    }

    open func doValidateEmail(for email: String,
                              with progress: PTCLProgressBlock?,
                              and block: PTCLValidationBlockVoidBoolDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doValidateEmail(for: email, with: progress, and: block)
    }

    open func doValidateHandle(for handle: String,
                               with progress: PTCLProgressBlock?,
                               and block: PTCLValidationBlockVoidBoolDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doValidateHandle(for: handle, with: progress, and: block)
    }

    open func doValidateName(for name: String,
                             with progress: PTCLProgressBlock?,
                             and block: PTCLValidationBlockVoidBoolDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doValidateName(for: name, with: progress, and: block)
    }
    
    open func doValidateNumber(for number: String,
                               with progress: PTCLProgressBlock?,
                               and block: PTCLValidationBlockVoidBoolDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doValidateNumber(for: number, with: progress, and: block)
    }
                                      
    open func doValidatePassword(for password: String,
                                 with progress: PTCLProgressBlock?,
                                 and block: PTCLValidationBlockVoidBoolDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doValidatePassword(for: password, with: progress, and: block)
    }

    open func doValidatePercentage(for percentage: String,
                                   with progress: PTCLProgressBlock?,
                                   and block: PTCLValidationBlockVoidBoolDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doValidatePercentage(for: percentage, with: progress, and: block)
    }

    open func doValidatePhone(for phone: String,
                              with progress: PTCLProgressBlock?,
                              and block: PTCLValidationBlockVoidBoolDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doValidatePhone(for: phone, with: progress, and: block)
    }

    open func doValidateSearch(for search: String,
                               with progress: PTCLProgressBlock?,
                               and block: PTCLValidationBlockVoidBoolDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doValidateSearch(for: search, with: progress, and: block)
    }

    open func doValidateState(for state: String,
                              with progress: PTCLProgressBlock?,
                              and block: PTCLValidationBlockVoidBoolDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doValidateState(for: state, with: progress, and: block)
    }

    open func doValidateUnsignedNumber(for number: String,
                                       with progress: PTCLProgressBlock?,
                                       and block: PTCLValidationBlockVoidBoolDNSError?) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doValidateUnsignedNumber(for: number, with: progress, and: block)
    }
}
