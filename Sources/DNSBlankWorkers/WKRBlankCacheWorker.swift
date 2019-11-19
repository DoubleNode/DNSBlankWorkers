//
//  WKRBlankAnalyticsWorker.swift
//  DoubleNode Core - DNSBlankWorkers
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankCacheWorker: PTCLCache_Protocol
{
    public var nextWorker: PTCLCache_Protocol?
    
    public required init() {
    }

    public required init(nextWorker: PTCLCache_Protocol) {
        self.nextWorker = nextWorker
    }

    open func configure() {
    }

    open func enableOption(option: String) {
        nextWorker?.enableOption(option: option)
    }

    open func disableOption(option: String) {
        nextWorker?.disableOption(option: option)
    }

    // MARK: - Business Logic / Single Item CRUD
    public func doDeleteObject(for id: String,
                               with progress: PTCLProgressBlock?,
                               and block: PTCLCacheBlockVoidAnyError?) throws {
        guard nextWorker != nil else {
            throw DNSBlankWorkersError.notImplemented(domain: "com.doublenode.\(type(of: self))",
                file: "\(#file)",
                line: "\(#line)",
                method: "\(#function)")
        }

        try nextWorker!.doDeleteObject(for: id, with: progress, and:block)
    }
    
    public func doReadObject(for id: String,
                             with progress: PTCLProgressBlock?,
                             and block: PTCLCacheBlockVoidAnyError?) throws {
        guard nextWorker != nil else {
            throw DNSBlankWorkersError.notImplemented(domain: "com.doublenode.\(type(of: self))",
                file: "\(#file)",
                line: "\(#line)",
                method: "\(#function)")
        }

        try nextWorker!.doReadObject(for: id, with: progress, and:block)
    }
    
    public func doLoadImage(for url: NSURL,
                            with progress: PTCLProgressBlock?,
                            and block: PTCLCacheBlockVoidAnyError?) throws {
        guard nextWorker != nil else {
            throw DNSBlankWorkersError.notImplemented(domain: "com.doublenode.\(type(of: self))",
                file: "\(#file)",
                line: "\(#line)",
                method: "\(#function)")
        }

        try nextWorker!.doLoadImage(for: url, with: progress, and:block)
    }
    
    public func doUpdateObject(for id: String,
                               with progress: PTCLProgressBlock?,
                               and block: PTCLCacheBlockVoidAnyError?) throws {
        guard nextWorker != nil else {
            throw DNSBlankWorkersError.notImplemented(domain: "com.doublenode.\(type(of: self))",
                file: "\(#file)",
                line: "\(#line)",
                method: "\(#function)")
        }

        try nextWorker!.doUpdateObject(for: id, with: progress, and:block)
    }
}
