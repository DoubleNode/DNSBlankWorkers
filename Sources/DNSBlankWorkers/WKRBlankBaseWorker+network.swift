//
//  WKRBlankBaseWorker+network.swift
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

public struct WKRPTCLSystemsStateData {
    public var system: String
    public var endPoint: String
    public var sendDebug: Bool
    
    public init(system: String, endPoint: String, sendDebug: Bool) {
        self.system = system
        self.endPoint = endPoint
        self.sendDebug = sendDebug
    }
}

public typealias WKRPTCLRequestBlkError = (Error) -> Void
public typealias WKRPTCLRequestBlkSuccess = (Any?) -> Result<Void, Error>

public extension WKRBlankBaseWorker {
    func processRequestJSON(_ callData: WKRPTCLSystemsStateData,
                            _ dataRequest: NETPTCLRouterRtnDataRequest,
                            with resultBlock: DNSPTCLResultBlock?,
                            onSuccess successBlk: WKRPTCLRequestBlkSuccess?,
                            onError errorBlk: WKRPTCLRequestBlkError?) {
        dataRequest.responseJSON(queue: DNSThreadingQueue.backgroundQueue.queue) { response in
            DNSCore.reportLog("URL=\"\(response.request?.url?.absoluteString ?? "<none>")\"")
            if case .failure(let error) = response.result {
                DNSCore.reportLog(error.localizedDescription)
                var error = DNSError.NetworkBase
                    .networkError(error: error, DNSCodeLocation.blankWorkers(self, "\(#file),\(#line),\(#function)"))
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == 401 {
                    error = DNSError.NetworkBase
                        .unauthorized(DNSCodeLocation.blankWorkers(self, "\(#file),\(#line),\(#function)"))
                }
                DNSCore.reportError(error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                errorBlk?(error)
                _ = resultBlock?(.error)
                return
            }
            let data = try! response.result.get()
            let statusCode = response.response?.statusCode ?? 0
            switch statusCode {
            case 0, 200...299:
                break
            case 401:
                var error = DNSError.NetworkBase
                    .unauthorized(DNSCodeLocation.blankWorkers(self, "\(#file),\(#line),\(#function)"))
                let valueData = Self.xlt.dictionary(from: data) as DNSDataDictionary
                let message = Self.xlt.string(from: valueData["error"] as Any?) ?? "Unknown"
                if message == "accountRole mismatch" {
                    error = DNSError.NetworkBase
                        .adminRequired(DNSCodeLocation.blankWorkers(self, "\(#file),\(#line),\(#function)"))
                }
                DNSCore.reportError(error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                errorBlk?(error)
                _ = resultBlock?(.error)
                return
            default:
                let error = DNSError.NetworkBase
                    .serverError(statusCode: statusCode, DNSCodeLocation.blankWorkers(self, "\(#file),\(#line),\(#function)"))
                DNSCore.reportError(error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                errorBlk?(error)
                _ = resultBlock?(.error)
                return
            }
            let result = successBlk?(data)
            if case .failure(let error) = result {
                DNSCore.reportError(error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                errorBlk?(error)
                _ = resultBlock?(.error)
                return
            }
            self.utilityReportSystemSuccess(for: callData.system, and: callData.endPoint)
            _ = resultBlock?(.completed)
        }
    }
}
