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

// Protocol Block Types
public typealias WKRPTCLRequestBlkError = (Error, Any?) -> Void
public typealias WKRPTCLRequestBlkPendingError = (Error, Any?) -> Error
public typealias WKRPTCLRequestBlkSuccess = (Any?) -> Result<Void, Error>

public extension WKRBlankBaseWorker {
    func processRequestJSON(_ dataRequest: NETPTCLRouterRtnDataRequest,
                            with resultBlock: DNSPTCLResultBlock?,
                            onSuccess successBlk: WKRPTCLRequestBlkSuccess?,
                            onError errorBlk: WKRPTCLRequestBlkError?,
                            onRetry retryBlk: WKRPTCLRequestBlkError? = nil) {
        self.processRequestJSON(.empty,
                                dataRequest,
                                with: resultBlock,
                                onSuccess: successBlk,
                                onPendingError: nil,
                                onError: errorBlk,
                                onRetry: retryBlk)
    }
    func processRequestJSON(_ callData: WKRPTCLSystemsStateData = .empty,
                            _ dataRequest: NETPTCLRouterRtnDataRequest,
                            with resultBlock: DNSPTCLResultBlock?,
                            onSuccess successBlk: WKRPTCLRequestBlkSuccess?,
                            onError errorBlk: WKRPTCLRequestBlkError?,
                            onRetry retryBlk: WKRPTCLRequestBlkError? = nil) {
        self.processRequestJSON(callData,
                                dataRequest,
                                with: resultBlock,
                                onSuccess: successBlk,
                                onPendingError: nil,
                                onError: errorBlk,
                                onRetry: retryBlk)
    }
    func processRequestJSON(_ callData: WKRPTCLSystemsStateData = .empty,
                            _ dataRequest: NETPTCLRouterRtnDataRequest,
                            with resultBlock: DNSPTCLResultBlock?,
                            onSuccess successBlk: WKRPTCLRequestBlkSuccess?,
                            onPendingError pendingBlk: WKRPTCLRequestBlkPendingError?,
                            onError errorBlk: WKRPTCLRequestBlkError?,
                            onRetry retryBlk: WKRPTCLRequestBlkError? = nil) {
        dataRequest.responseJSON(queue: DNSThreadingQueue.backgroundQueue.queue) { response in
            DNSCore.reportLog("URL=\"\(response.request?.url?.absoluteString ?? "<none>")\"")
            if case .failure(let error) = response.result {
                DNSCore.reportLog(error.localizedDescription)
                var error = DNSError.NetworkBase.networkError(error: error, .blankWorkers(self))
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == 401 {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                }
                DNSCore.reportError(error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                return
            }
            let data = try! response.result.get()
            let url = response.request?.url
            let statusCode = response.response?.statusCode ?? 0
            switch statusCode {
            case 0, 200...299:
                break
            case 400, 401:
                var error = DNSError.NetworkBase
                    .serverError(statusCode: statusCode, .blankWorkers(self))
                let valueData = Self.xlt.dictionary(from: data) as DNSDataDictionary
                let message = self.utilityErrorMessage(from: valueData)
                if message == "Unauthorized" {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                }
                if message == "Admin Support Required" {
                    error = DNSError.NetworkBase.adminRequired(.blankWorkers(self))
                }
                DNSCore.reportError(error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                return
            case 403:
                var error = DNSError.NetworkBase.forbidden(.blankWorkers(self))
                let valueData = Self.xlt.dictionary(from: data) as DNSDataDictionary
                let message = self.utilityErrorMessage(from: valueData)
                if message == "Missing/Invalid accessToken" {
                    error = DNSError.NetworkBase.forbidden(.blankWorkers(self))
                }
                if message == "Outdated Client" {
                    let details = self.utilityErrorDetails(from: valueData)
                    error = DNSError.NetworkBase.upgradeClient(message: details, .blankWorkers(self))
                }
                DNSCore.reportError(error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                return
            case 422:
                let error = DNSError.NetworkBase.dataError(.blankWorkers(self))
                DNSCore.reportError(error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                return
            case 500...599:
                let error = DNSError.NetworkBase.serverError(statusCode: statusCode, .blankWorkers(self))
                guard let url else { fallthrough }
                let retryCount = self.utilityNewRetryCount(for: url)
                let delay = self.utilityRetryDelay(for: retryCount)
                guard delay >= 0 else { fallthrough }
                guard let retryBlk else { fallthrough }
                DNSUIThread.run(after: delay) { // TODO: DNSThread
                    retryBlk(error, data)
                }
                return
            default:
                let error = DNSError.NetworkBase
                    .serverError(statusCode: statusCode, .blankWorkers(self))
                DNSCore.reportError(error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                return
            }
            if let url {
                self.utilityResetRetryCount(for: url)
            }
            let result = successBlk?(data)
            if case .failure(let error) = result {
                DNSCore.reportError(error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                return
            }
            self.utilityReportSystemSuccess(for: callData.system, and: callData.endPoint)
            _ = resultBlock?(.completed)
        }
    }
}
