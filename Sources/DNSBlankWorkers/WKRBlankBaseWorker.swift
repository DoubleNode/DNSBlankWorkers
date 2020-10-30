//
//  WKRBlankBaseWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import AtomicSwift
import DNSProtocols
import Foundation

public enum WKRBlankBaseWorkerError: Error
{
    case dataError(domain: String, file: String, line: String, method: String)
    case invalidUrl(domain: String, file: String, line: String, method: String)
    case networkError(domain: String, file: String, line: String, method: String)
    case noAccounts(domain: String, file: String, line: String, method: String)
}
extension WKRBlankBaseWorkerError: DNSError {
    public var nsError: NSError! {
        switch self {
        case .dataError(let domain, let file, let line, let method):
            let userInfo: [String : Any] = ["DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                                            NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"]
            return NSError.init(domain: domain, code: -9999, userInfo: userInfo)
        case .invalidUrl(let domain, let file, let line, let method):
            let userInfo: [String : Any] = ["DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                                            NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"]
            return NSError.init(domain: domain, code: -9999, userInfo: userInfo)
        case .networkError(let domain, let file, let line, let method):
            let userInfo: [String : Any] = ["DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                                            NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"]
            return NSError.init(domain: domain, code: -9999, userInfo: userInfo)
        case .noAccounts(let domain, let file, let line, let method):
            let userInfo: [String : Any] = ["DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                                            NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"]
            return NSError.init(domain: domain, code: -9999, userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        switch self {
        case .dataError(let domain, let file, let line, let method):
            return NSLocalizedString("Data error (\(domain):\(file):\(line):\(method))", comment: "")
        case .invalidUrl(let domain, let file, let line, let method):
            return NSLocalizedString("Invalid URL (\(domain):\(file):\(line):\(method))", comment: "")
        case .networkError(let domain, let file, let line, let method):
            return NSLocalizedString("Network error (\(domain):\(file):\(line):\(method))", comment: "")
        case .noAccounts(let domain, let file, let line, let method):
            return NSLocalizedString("No matching accounts found (\(domain):\(file):\(line):\(method))", comment: "")
        }
    }
}

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
}
