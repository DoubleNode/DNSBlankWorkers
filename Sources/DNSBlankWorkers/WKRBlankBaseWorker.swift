//
//  WKRBlankBaseWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
import AtomicSwift
import DNSCore
import DNSProtocols
import Foundation

open class WKRBlankBaseWorker: WKRBaseWorker {
    public var systemsWorker: WKRPTCLSystems? = WKRBlankSystemsWorker()

    // MARK: - Utility methods
    open func utilityReportSystemSuccess(for systemId: String,
                                         and endPointId: String) {
        self.utilityReportSystem(debugString: "",
                                 result: WKRPTCLSystemsData.Result.success,
                                 and: "",
                                 for: systemId,
                                 and: endPointId)
    }
    open func utilityReportSystemFailure(sendDebug: Bool,
                                         response: DataResponse<Data, AFError>,
                                         and failureCode: String,
                                         for systemId: String,
                                         and endPointId: String) {
        self.utilityReportSystem(debugString: sendDebug ? response.debugDescription : "",
                                 result: WKRPTCLSystemsData.Result.failure,
                                 and: failureCode,
                                 for: systemId,
                                 and: endPointId)
    }
    open func utilityReportSystemFailure(sendDebug: Bool,
                                         response: DataResponse<Data?, AFError>,
                                         and failureCode: String,
                                         for systemId: String,
                                         and endPointId: String) {
        self.utilityReportSystem(debugString: sendDebug ? response.debugDescription : "",
                                 result: WKRPTCLSystemsData.Result.failure,
                                 and: failureCode,
                                 for: systemId,
                                 and: endPointId)
    }
    open func utilityReportSystemFailure(sendDebug: Bool,
                                         response: DataResponse<Any, AFError>,
                                         and failureCode: String,
                                         for systemId: String,
                                         and endPointId: String) {
        self.utilityReportSystem(debugString: sendDebug ? response.debugDescription : "",
                                 result: WKRPTCLSystemsData.Result.failure,
                                 and: failureCode,
                                 for: systemId,
                                 and: endPointId)
    }
    open func utilityReportSystemFailure(sendDebug: Bool,
                                         debugString: String,
                                         and failureCode: String,
                                         for systemId: String,
                                         and endPointId: String) {
        self.utilityReportSystem(debugString: sendDebug ? debugString : "",
                                 result: WKRPTCLSystemsData.Result.failure,
                                 and: failureCode,
                                 for: systemId,
                                 and: endPointId)
    }
    open func utilityReportSystem(debugString: String,
                                  result: WKRPTCLSystemsData.Result,
                                  and failureCode: String,
                                  for systemId: String,
                                  and endPointId: String) {
        _ = self.systemsWorker?.doReport(result: result,
                                         and: failureCode,
                                         and: debugString,
                                         for: systemId,
                                         and: endPointId, with: nil)
    }
}
