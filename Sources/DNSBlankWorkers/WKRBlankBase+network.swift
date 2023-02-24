//
//  WKRBlankBase+network.swift
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
public typealias WKRPTCLRequestBlkSystemResult = (Error, Any?) -> WKRPTCLSystemsData.Result
public typealias WKRPTCLRequestBlkSuccess = (Any?) -> Result<Void, Error>
public typealias WKRPTCLRequestBlkSuccessData = (Data) -> Result<Void, Error>

public extension WKRBlankBase {
    func processRequestJSON(_ callData: WKRPTCLSystemsStateData = .empty,
                            _ dataRequest: NETPTCLRouterRtnDataRequest,
                            with resultBlock: DNSPTCLResultBlock?,
                            onSuccess successBlk: WKRPTCLRequestBlkSuccess? = nil,
                            onPendingError pendingBlk: WKRPTCLRequestBlkPendingError? = nil,
                            onError errorBlk: WKRPTCLRequestBlkError? = nil,
                            systemResult systemResultBlk: WKRPTCLRequestBlkSystemResult? = nil,
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
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
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
                if message == "Access token was not provided" {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Token has been revoked." {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Unauthorized" {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Admin Support Required" {
                    error = DNSError.NetworkBase.adminRequired(.blankWorkers(self))
                } else if message == "Insufficient Access" {
                    error = DNSError.NetworkBase.insufficientAccess(.blankWorkers(self))
                }
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            case 403:
                var error = DNSError.NetworkBase.forbidden(.blankWorkers(self))
                let valueData = Self.xlt.dictionary(from: data) as DNSDataDictionary
                let message = self.utilityErrorMessage(from: valueData)
                if message == "Access token was not provided" {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Token has been revoked." {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Missing/Invalid accessToken" {
                    error = DNSError.NetworkBase.forbidden(.blankWorkers(self))
                } else if message == "Expired accessToken" {
                    error = DNSError.NetworkBase.expiredAccessToken(.blankWorkers(self))
                } else if message == "Outdated Client" {
                    let details = self.utilityErrorDetails(from: valueData)
                    error = DNSError.NetworkBase.upgradeClient(message: details, .blankWorkers(self))
                }
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            case 404:
                var error: DNSError = DNSError.NetworkBase.notFound(field: "any", value: "any", .blankWorkers(self))
                let valueData = Self.xlt.dictionary(from: data) as DNSDataDictionary
                let message = self.utilityErrorMessage(from: valueData)
                if message == "Already Linked" {
                    error = DNSError.NetworkBase.alreadyLinked(.blankWorkers(self))
                }
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            case 422:
                let error = DNSError.NetworkBase.dataError(.blankWorkers(self))
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
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
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            }
            if let url {
                self.utilityResetRetryCount(for: url)
            }
            let result = successBlk?(data)
            if case .failure(let error) = result {
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            }
            _ = resultBlock?(.completed)
            self.utilityReportSystemSuccess(for: callData.system, and: callData.endPoint)
        }
    }
    func processRequest(_ callData: WKRPTCLSystemsStateData = .empty,
                        _ dataRequest: NETPTCLRouterRtnDataRequest,
                        with resultBlock: DNSPTCLResultBlock?,
                        onSuccess successBlk: WKRPTCLRequestBlkSuccess? = nil,
                        onPendingError pendingBlk: WKRPTCLRequestBlkPendingError? = nil,
                        onError errorBlk: WKRPTCLRequestBlkError? = nil,
                        systemResult systemResultBlk: WKRPTCLRequestBlkSystemResult? = nil,
                        onRetry retryBlk: WKRPTCLRequestBlkError? = nil) {
        dataRequest.response(queue: DNSThreadingQueue.backgroundQueue.queue) { response in
            DNSCore.reportLog("URL=\"\(response.request?.url?.absoluteString ?? "<none>")\"")
            if case .failure(let error) = response.result {
                DNSCore.reportLog(error.localizedDescription)
                var error = DNSError.NetworkBase.networkError(error: error, .blankWorkers(self))
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == 401 {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                }
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
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
                if message == "Access token was not provided" {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Token has been revoked." {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Unauthorized" {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Admin Support Required" {
                    error = DNSError.NetworkBase.adminRequired(.blankWorkers(self))
                } else if message == "Insufficient Access" {
                    error = DNSError.NetworkBase.insufficientAccess(.blankWorkers(self))
                }
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            case 403:
                var error = DNSError.NetworkBase.forbidden(.blankWorkers(self))
                let valueData = Self.xlt.dictionary(from: data) as DNSDataDictionary
                let message = self.utilityErrorMessage(from: valueData)
                if message == "Access token was not provided" {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Token has been revoked." {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Missing/Invalid accessToken" {
                    error = DNSError.NetworkBase.forbidden(.blankWorkers(self))
                } else if message == "Expired accessToken" {
                    error = DNSError.NetworkBase.expiredAccessToken(.blankWorkers(self))
                } else if message == "Outdated Client" {
                    let details = self.utilityErrorDetails(from: valueData)
                    error = DNSError.NetworkBase.upgradeClient(message: details, .blankWorkers(self))
                }
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            case 404:
                var error: DNSError = DNSError.NetworkBase.notFound(field: "any", value: "any", .blankWorkers(self))
                let valueData = Self.xlt.dictionary(from: data) as DNSDataDictionary
                let message = self.utilityErrorMessage(from: valueData)
                if message == "Already Linked" {
                    error = DNSError.NetworkBase.alreadyLinked(.blankWorkers(self))
                }
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            case 422:
                let error = DNSError.NetworkBase.dataError(.blankWorkers(self))
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
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
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            }
            if let url {
                self.utilityResetRetryCount(for: url)
            }
            let result = successBlk?(data)
            if case .failure(let error) = result {
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            }
            _ = resultBlock?(.completed)
            self.utilityReportSystemSuccess(for: callData.system, and: callData.endPoint)
        }
    }
    func processRequestData(_ callData: WKRPTCLSystemsStateData = .empty,
                            _ dataRequest: NETPTCLRouterRtnDataRequest,
                            with resultBlock: DNSPTCLResultBlock?,
                            onSuccess successBlk: WKRPTCLRequestBlkSuccessData? = nil,
                            onPendingError pendingBlk: WKRPTCLRequestBlkPendingError? = nil,
                            onError errorBlk: WKRPTCLRequestBlkError? = nil,
                            systemResult systemResultBlk: WKRPTCLRequestBlkSystemResult? = nil,
                            onRetry retryBlk: WKRPTCLRequestBlkError? = nil) {
        dataRequest.responseData(queue: DNSThreadingQueue.backgroundQueue.queue) { response in
            DNSCore.reportLog("URL=\"\(response.request?.url?.absoluteString ?? "<none>")\"")
            if case .failure(let error) = response.result {
                DNSCore.reportLog(error.localizedDescription)
                var error = DNSError.NetworkBase.networkError(error: error, .blankWorkers(self))
                let statusCode = response.response?.statusCode ?? 0
                if statusCode == 401 {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                }
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
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
                if message == "Access token was not provided" {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Token has been revoked." {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Unauthorized" {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Admin Support Required" {
                    error = DNSError.NetworkBase.adminRequired(.blankWorkers(self))
                } else if message == "Insufficient Access" {
                    error = DNSError.NetworkBase.insufficientAccess(.blankWorkers(self))
                }
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            case 403:
                var error = DNSError.NetworkBase.forbidden(.blankWorkers(self))
                let valueData = Self.xlt.dictionary(from: data) as DNSDataDictionary
                let message = self.utilityErrorMessage(from: valueData)
                if message == "Access token was not provided" {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Token has been revoked." {
                    error = DNSError.NetworkBase.unauthorized(.blankWorkers(self))
                } else if message == "Missing/Invalid accessToken" {
                    error = DNSError.NetworkBase.forbidden(.blankWorkers(self))
                } else if message == "Expired accessToken" {
                    error = DNSError.NetworkBase.expiredAccessToken(.blankWorkers(self))
                } else if message == "Outdated Client" {
                    let details = self.utilityErrorDetails(from: valueData)
                    error = DNSError.NetworkBase.upgradeClient(message: details, .blankWorkers(self))
                }
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            case 404:
                var error: DNSError = DNSError.NetworkBase.notFound(field: "any", value: "any", .blankWorkers(self))
                let valueData = Self.xlt.dictionary(from: data) as DNSDataDictionary
                let message = self.utilityErrorMessage(from: valueData)
                if message == "Already Linked" {
                    error = DNSError.NetworkBase.alreadyLinked(.blankWorkers(self))
                }
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            case 422:
                let error = DNSError.NetworkBase.dataError(.blankWorkers(self))
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
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
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            }
            if let url {
                self.utilityResetRetryCount(for: url)
            }
            let result = successBlk?(data)
            if case .failure(let error) = result {
                DNSCore.reportError(error)
                let finalError = pendingBlk?(error, nil) ?? error
                errorBlk?(finalError, nil)
                _ = resultBlock?(.error)
                self.utilityReportSystemFailure(sendDebug: callData.sendDebug,
                                                response: response,
                                                result: systemResultBlk?(finalError, nil) ?? .failure,
                                                and: statusCode == 0 ? "" : "\(statusCode)",
                                                for: callData.system, and: callData.endPoint)
                return
            }
            _ = resultBlock?(.completed)
            self.utilityReportSystemSuccess(for: callData.system, and: callData.endPoint)
        }
    }
}
