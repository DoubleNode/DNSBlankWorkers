//
//  WKRBase.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
import AtomicSwift
import DNSCore
import DNSCrashNetwork
import DNSDataObjects
import DNSProtocols
import Foundation

open class WKRBase: NSObject, WKRPTCLWorkerBase {
    public static var xlt = DNSDataTranslation()
    
    static public var languageCode: String {
        DNSCore.languageCode
    }
    
    @Atomic
    private var options: [String] = []
    
    public var netConfig: NETPTCLConfig = NETCrashConfig()
    public var netRouter: NETPTCLRouter = NETCrashRouter()
    
    override public required init() {
        super.init()
    }
    open func configure() { }
    
    public func checkOption(_ option: String) -> Bool {
        return self.options.contains(option)
    }
    open func enableOption(_ option: String) {
        guard !self.checkOption(option) else { return }
        self.options.append(option)
    }
    open func disableOption(_ option: String) {
        self.options.removeAll { $0 == option }
    }
    
    // MARK: - UIWindowSceneDelegate methods
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    open func didBecomeActive() { }
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    open func willResignActive() { }
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    open func willEnterForeground() { }
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    open func didEnterBackground() { }
    
    open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                   with error: Error) -> DNSPTCLWorker.Call.Result {
        return result
    }
    open func runDo(callNextWhen: DNSPTCLWorker.Call.NextWhen,
                    runNext: DNSPTCLCallBlock?,
                    doWork: DNSPTCLCallResultBlock) -> Any? {
        let resultBlock: DNSPTCLResultBlock = { result in
            var result = result
            if case .failure(let error) = result {
                result = self.confirmFailureResult(result, with: error)
            }
            switch result {
            case .completed:
                guard [.always].contains(where: { $0 == callNextWhen }) else { return nil }
            case .error, .failure:
                guard [.always, .whenError].contains(where: { $0 == callNextWhen }) else { return nil }
            case .notFound:
                guard [.always, .whenNotFound].contains(where: { $0 == callNextWhen }) else { return nil }
            case .unhandled:
//                guard [.always, .whenUnhandled].contains(where: { $0 == callNextWhen }) else { return nil }
                break
            }
            return runNext?()
        }
        return doWork(resultBlock)
    }
    
    // MARK: - Worker Logic (Public) -
    open func doAnalytics(for object: DAOBaseObject,
                          using data: DNSDataDictionary,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLWorkerBaseBlkAAnalyticsData?) { }
    
    // MARK: - Worker Logic (Shortcuts) -
    public func doAnalytics(for object: DAOBaseObject,
                            using data: DNSDataDictionary,
                            and block: WKRPTCLWorkerBaseBlkAAnalyticsData?) {
        self.doAnalytics(for: object, using: data, with: nil, and: block)
    }
    
    // MARK: - Internal Work Methods
    open func intDoAnalytics(for object: DAOBaseObject,
                             using data: DNSDataDictionary,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLWorkerBaseBlkAAnalyticsData?,
                             then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
}
