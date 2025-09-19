//
//  WKRBlankValidation.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankValidation: WKRBlankBase, WKRPTCLValidation {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled

    public var nextWKRPTCLValidation: WKRPTCLValidation? {
        get { return nextWorker as? WKRPTCLValidation }
        set { nextWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLValidation,
                         for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.callNextWhen = callNextWhen
        self.nextWKRPTCLValidation = nextWorker
    }

    override open func disableOption(_ option: String) {
        super.disableOption(option)
        nextWKRPTCLValidation?.disableOption(option)
    }
    override open func enableOption(_ option: String) {
        super.enableOption(option)
        nextWKRPTCLValidation?.enableOption(option)
    }
    @discardableResult
    public func runDo(runNext: DNSPTCLCallBlock?,
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWKRPTCLValidation != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Validation.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doValidateAddress(for address: DNSPostalAddress?,
                                  with config: Config.Address) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateAddress(for: address, with: config)
        },
                          doWork: {
            return self.intDoValidateAddress(for: address, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidateAddressCity(for city: String?,
                                      with config: Config.Address.City) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateAddressCity(for: city, with: config)
        },
                          doWork: {
            return self.intDoValidateAddressCity(for: city, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidateAddressPostalCode(for postalCode: String?,
                                            with config: Config.Address.PostalCode) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateAddressPostalCode(for: postalCode, with: config)
        },
                          doWork: {
            return self.intDoValidateAddressPostalCode(for: postalCode, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidateAddressState(for state: String?,
                                       with config: Config.Address.State) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateAddressState(for: state, with: config)
        },
                          doWork: {
            return self.intDoValidateAddressState(for: state, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidateAddressStreet(for street: String?,
                                        with config: Config.Address.Street) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateAddressStreet(for: street, with: config)
        },
                          doWork: {
            return self.intDoValidateAddressStreet(for: street, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidateAddressStreet2(for street2: String?,
                                         with config: Config.Address.Street2) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateAddressStreet2(for: street2, with: config)
        },
                          doWork: {
            return self.intDoValidateAddressStreet2(for: street2, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidateBirthdate(for birthdate: Date?,
                                    with config: WKRPTCLValidation.Data.Config.Birthdate) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateBirthdate(for: birthdate, with: config)
        },
                          doWork: {
            return self.intDoValidateBirthdate(for: birthdate, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidateCalendarDate(for date: Date?,
                                       with config: WKRPTCLValidation.Data.Config.CalendarDate) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateCalendarDate(for: date, with: config)
        },
                          doWork: {
            return self.intDoValidateCalendarDate(for: date, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidateEmail(for email: String?,
                                with config: WKRPTCLValidation.Data.Config.Email) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateEmail(for: email, with: config)
        },
                          doWork: {
            return self.intDoValidateEmail(for: email, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidateHandle(for handle: String?,
                                 with config: WKRPTCLValidation.Data.Config.Handle) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateHandle(for: handle, with: config)
        },
                          doWork: {
            return self.intDoValidateHandle(for: handle, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidateName(for name: String?,
                               with config: WKRPTCLValidation.Data.Config.Name) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateName(for: name, with: config)
        },
                          doWork: {
            return self.intDoValidateName(for: name, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidateNumber(for number: String?,
                                 with config: WKRPTCLValidation.Data.Config.Number) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateNumber(for: number, with: config)
        },
                          doWork: {
            return self.intDoValidateNumber(for: number, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidatePassword(for password: String?,
                                   with config: WKRPTCLValidation.Data.Config.Password) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidatePassword(for: password, with: config)
        },
                          doWork: {
            return self.intDoValidatePassword(for: password, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidatePercentage(for percentage: String?,
                                     with config: WKRPTCLValidation.Data.Config.Percentage) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidatePercentage(for: percentage, with: config)
        },
                          doWork: {
            return self.intDoValidatePercentage(for: percentage, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidatePhone(for phone: String?,
                                with config: WKRPTCLValidation.Data.Config.Phone) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidatePhone(for: phone, with: config)
        },
                          doWork: {
            return self.intDoValidatePhone(for: phone, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidateSearch(for search: String?,
                                 with config: WKRPTCLValidation.Data.Config.Search) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateSearch(for: search, with: config)
        },
                          doWork: {
            return self.intDoValidateSearch(for: search, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidateState(for state: String?,
                                with config: WKRPTCLValidation.Data.Config.State) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateState(for: state, with: config)
        },
                          doWork: {
            return self.intDoValidateState(for: state, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }
    public func doValidateUnsignedNumber(for number: String?,
                                         with config: WKRPTCLValidation.Data.Config.UnsignedNumber) -> WKRPTCLValidationResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLValidation?.doValidateUnsignedNumber(for: number, with: config)
        },
                          doWork: {
            return self.intDoValidateUnsignedNumber(for: number, with: config, then: $0)
        }) as! WKRPTCLValidationResVoid // swiftlint:disable:this force_cast
    }

    // MARK: - Internal Work Methods
    open func intDoValidateAddress(for address: DNSPostalAddress?,
                                   with config: Config.Address,
                                   then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidateAddressCity(for city: String?,
                                       with config: Config.Address.City,
                                       then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidateAddressPostalCode(for postalCode: String?,
                                             with config: Config.Address.PostalCode,
                                             then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidateAddressState(for state: String?,
                                        with config: Config.Address.State,
                                        then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidateAddressStreet(for street: String?,
                                         with config: Config.Address.Street,
                                         then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidateAddressStreet2(for street2: String?,
                                          with config: Config.Address.Street2,
                                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidateBirthdate(for birthdate: Date?,
                                     with config: WKRPTCLValidation.Data.Config.Birthdate,
                                     then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidateCalendarDate(for date: Date?,
                                        with config: WKRPTCLValidation.Data.Config.CalendarDate,
                                        then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidateEmail(for email: String?,
                                 with config: WKRPTCLValidation.Data.Config.Email,
                                 then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidateHandle(for handle: String?,
                                  with config: WKRPTCLValidation.Data.Config.Handle,
                                  then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidateName(for name: String?,
                                with config: WKRPTCLValidation.Data.Config.Name,
                                then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidateNumber(for number: String?,
                                  with config: WKRPTCLValidation.Data.Config.Number,
                                  then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidatePassword(for password: String?,
                                    with config: WKRPTCLValidation.Data.Config.Password,
                                    then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidatePercentage(for percentage: String?,
                                      with config: WKRPTCLValidation.Data.Config.Percentage,
                                      then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidatePhone(for phone: String?,
                                 with config: WKRPTCLValidation.Data.Config.Phone,
                                 then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidateSearch(for search: String?,
                                  with config: WKRPTCLValidation.Data.Config.Search,
                                  then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidateState(for state: String?,
                                 with config: WKRPTCLValidation.Data.Config.State,
                                 then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    open func intDoValidateUnsignedNumber(for number: String?,
                                          with config: WKRPTCLValidation.Data.Config.UnsignedNumber,
                                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLValidationResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
}
