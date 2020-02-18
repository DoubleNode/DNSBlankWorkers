//
//  WKRBlankAuthenticationWorker.swift
//  DoubleNode Core - DNSBlankWorkers
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankAuthenticationWorker: WKRBlankBaseWorker, PTCLAuthentication_Protocol
{
    public var nextWorker: PTCLAuthentication_Protocol?

    public required init() {
        super.init()
    }

    public required init(nextWorker: PTCLAuthentication_Protocol) {
        super.init()
        self.nextWorker = nextWorker
    }

    override open func enableOption(option: String) {
        nextWorker?.enableOption(option: option)
    }

    override open func disableOption(option: String) {
        nextWorker?.disableOption(option: option)
    }

    // MARK: - Business Logic / Single Item CRUD

    open func doCheckAuthentication(using parameters: [String: Any],
                                    with progress: PTCLProgressBlock?,
                                    and block: PTCLAuthenticationBlockVoidBoolAccessDataDNSError) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doCheckAuthentication(using: parameters,
                                              with: progress,
                                              and: block)
    }

    open func doSignIn(from username: String?,
                       and password: String?,
                       using parameters: [String: Any],
                       with progress: PTCLProgressBlock?,
                       and block: @escaping PTCLAuthenticationBlockVoidBoolAccessDataDNSError) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doSignIn(from: username,
                                 and: password,
                                 using: parameters,
                                 with: progress,
                                 and: block)
    }

    open func doSignOut(using parameters: [String: Any],
                        with progress: PTCLProgressBlock?,
                        and block: @escaping PTCLAuthenticationBlockVoidBoolDNSError) throws {
        guard nextWorker != nil else {
            return
        }

        try nextWorker!.doSignOut(using: parameters,
                                  with: progress,
                                  and: block)
    }
}
