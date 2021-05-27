//
//  WKRBlankBaseWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import AtomicSwift
import DNSCore
import DNSProtocols
import Foundation

open class WKRBlankBaseWorker: NSObject, PTCLBase_Protocol
{
    @Atomic
    private var options: [String] = []
    
    public var networkConfigurator: PTCLBase_NetworkConfigurator?
    
    static public var languageCode: String = {
        let currentLocale = NSLocale.current
        var languageCode = currentLocale.languageCode ?? "en"
        if languageCode == "es" {
            languageCode = "es-419"
        }
        return languageCode
    }()
    
    override public required init() {
        super.init()
    }
    open func configure() {
    }

    public func checkOption(_ option: String) -> Bool {
        return self.options.contains(option)
    }
    open func enableOption(_ option: String) {
        if !self.checkOption(option) {
            self.options.append(option)
        }
    }
    open func disableOption(_ option: String) {
        self.options.removeAll { $0 == option }
    }

    open func defaultHeaders() -> [String: String] {
        
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language": "\(WKRBlankBaseWorker.languageCode), en;q=0.5, *;q=0.1"
        ]
    }
    
    // MARK: - UIWindowSceneDelegate methods

    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    open func didBecomeActive() {
    }

    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    open func willResignActive() {
    }

    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    open func willEnterForeground() {
    }

    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    open func didEnterBackground() {
    }

    public func runDo(callNextWhen: PTCLCallNextWhen,
                      runNext: PTCLCallBlock?,
                      doWork: PTCLCallResultBlockThrows) throws -> Any? {
        let resultBlock: PTCLResultBlock = { callResult in
            switch callResult {
            case .completed:
                guard [.always].contains(where: { $0 == callNextWhen }) else { return nil }
                do {
                    return try runNext?()
                } catch { }
            case .error:
                guard [.always, .whenError].contains(where: { $0 == callNextWhen }) else { return nil }
                do {
                    return try runNext?()
                } catch { }
            case .notFound:
                guard [.always, .whenNotFound].contains(where: { $0 == callNextWhen }) else { return nil }
                do {
                    return try runNext?()
                } catch { }
            case .unhandled:
//                guard [.always, .whenUnhandled].contains(where: { $0 == callNextWhen }) else { return nil }
                do {
                    return try runNext?()
                } catch { }
            }
            return nil
        }
        return try doWork(resultBlock)
    }
}
