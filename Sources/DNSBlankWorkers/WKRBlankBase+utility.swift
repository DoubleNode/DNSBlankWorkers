//
//  WKRBlankBase+utility.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
import AtomicSwift
import DNSCore
import DNSCoreThreading
import DNSError
import DNSProtocols
import Foundation

public extension WKRBlankBase {
    // MARK: - Utility methods -
    func utilityErrorDetails(from data: DNSDataDictionary) -> String {
        var details = ""
        var errorData = Self.xlt.dictionary(from: data["error"] as Any?)
        if errorData.isEmpty {
            let metadata = Self.xlt.dictionary(from: data["metadata"] as Any?)
            if !metadata.isEmpty {
                errorData = Self.xlt.dictionary(from: metadata["error"] as Any?)
            }
        }
        if !errorData.isEmpty {
            details = Self.xlt.string(from: errorData["details"] as Any?) ?? ""
        } else {
            details = Self.xlt.string(from: data["errorDetails"] as Any?) ?? ""
        }
        return details
    }
    func utilityErrorMessage(from data: DNSDataDictionary) -> String {
        var message = ""
        var errorData = Self.xlt.dictionary(from: data["error"] as Any?)
        if errorData.isEmpty {
            let metadata = Self.xlt.dictionary(from: data["metadata"] as Any?)
            if !metadata.isEmpty {
                errorData = Self.xlt.dictionary(from: metadata["error"] as Any?)
            }
        }
        if !errorData.isEmpty {
            message = Self.xlt.string(from: errorData["message"] as Any?) ?? ""
        } else {
            message = Self.xlt.string(from: data["error"] as Any?) ?? ""
            if message.isEmpty {
                message = Self.xlt.string(from: data["message"] as Any?) ?? ""
            }
        }
        if message.isEmpty { message = "Unknown" }
        return message
    }
    func utilityNewRetryCount(for url: URL) -> Int {
        let newRetryCount = (self.retryCounts[url] ?? 0) + 1
        self.retryCounts[url] = newRetryCount
        return newRetryCount
    }
    func utilityResetRetryCount(for url: URL) {
        self.retryCounts[url] = 0
    }
    func utilityRetryDelay(for retryCount: Int) -> Double {
        switch retryCount {
        case 0...1: return Double(0)
        case 2...3: return Double(1)
//        case 4...5: return Double(5)
//        case 6...7: return Double(10)
        default:
            return -1
        }
    }
}
