//
//  WKRBlankAnalytics.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankAnalytics: WKRBaseAnalytics {
    // MARK: - Internal Work Methods
    override open func intDoAutoTrack(class: String, method: String, properties: DNSDataDictionary, options: DNSDataDictionary,
                             then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    override open func intDoGroup(groupId: String, traits: DNSDataDictionary, options: DNSDataDictionary,
                         then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    override open func intDoIdentify(userId: String, traits: DNSDataDictionary, options: DNSDataDictionary,
                            then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    override open func intDoScreen(screenTitle: String, properties: DNSDataDictionary, options: DNSDataDictionary,
                          then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
    override open func intDoTrack(event: WKRPTCLAnalyticsEvents, properties: DNSDataDictionary = [:], options: DNSDataDictionary = [:],
                         then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLAnalyticsResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
}
