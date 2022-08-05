//
//  WKRBlankBaseWorker+utility.swift
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

public extension WKRBlankBaseWorker {
    // MARK: - Utility methods -
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
