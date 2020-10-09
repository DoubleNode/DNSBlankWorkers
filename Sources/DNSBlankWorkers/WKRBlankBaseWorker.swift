//
//  WKRBlankBaseWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSProtocols
import Foundation

open class WKRBlankBaseWorker: NSObject, PTCLBase_Protocol
{
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

    open func enableOption(option: String) {
    }

    open func disableOption(option: String) {
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
