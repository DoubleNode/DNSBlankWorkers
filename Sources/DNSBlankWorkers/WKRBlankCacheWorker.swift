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

    // MARK: - UIWindowSceneDelegate methods

    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    public func didBecomeActive() {
    }

    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    public func willResignActive() {
    }

    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    public func willEnterForeground() {
    }

    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    public func didEnterBackground() {
    }

    // MARK: - Business Logic / Single Item CRUD
    open func doDeleteObject(for id: String,
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

    open func doReadObject(for id: String,
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

    open func doLoadImage(for url: NSURL,
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

    open func doUpdateObject(for id: String,
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
