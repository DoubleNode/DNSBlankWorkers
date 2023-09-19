//
//  WKRBlankBase.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
import AtomicSwift
import DNSCore
import DNSProtocols
import Foundation

open class WKRBlankBase: WKRBase {
    @Atomic public var retryCounts: [URL: Int] = [:]
    public var wkrSystems: WKRPTCLSystems?

    // MARK: - Utility methods
    open func utilityReportSystemSuccess(result: WKRPTCLSystemsData.Result = .success,
                                         for systemId: String,
                                         and endPointId: String) {
        self.utilityReportSystem(debugString: "",
                                 result: result,
                                 and: "",
                                 for: systemId,
                                 and: endPointId)
    }
    open func utilityReportSystemFailure(sendDebug: Bool,
                                         response: DataResponse<Data, AFError>,
                                         result: WKRPTCLSystemsData.Result = .failure,
                                         and failureCode: String,
                                         for systemId: String,
                                         and endPointId: String) {
        self.utilityReportSystem(debugString: sendDebug ? response.debugDescription : "",
                                 result: result,
                                 and: failureCode,
                                 for: systemId,
                                 and: endPointId)
    }
    open func utilityReportSystemFailure(sendDebug: Bool,
                                         response: DataResponse<Data?, AFError>,
                                         result: WKRPTCLSystemsData.Result = .failure,
                                         and failureCode: String,
                                         for systemId: String,
                                         and endPointId: String) {
        self.utilityReportSystem(debugString: sendDebug ? response.debugDescription : "",
                                 result: result,
                                 and: failureCode,
                                 for: systemId,
                                 and: endPointId)
    }
    open func utilityReportSystemFailure(sendDebug: Bool,
                                         response: DataResponse<Any, AFError>,
                                         result: WKRPTCLSystemsData.Result = .failure,
                                         and failureCode: String,
                                         for systemId: String,
                                         and endPointId: String) {
        self.utilityReportSystem(debugString: sendDebug ? response.debugDescription : "",
                                 result:result,
                                 and: failureCode,
                                 for: systemId,
                                 and: endPointId)
    }
    open func utilityReportSystemFailure<T: Decodable>(sendDebug: Bool,
                                                       response: DataResponse<T, AFError>,
                                                       result: WKRPTCLSystemsData.Result = .failure,
                                                       and failureCode: String,
                                                       for systemId: String,
                                                       and endPointId: String) {
        self.utilityReportSystem(debugString: sendDebug ? response.debugDescription : "",
                                 result:result,
                                 and: failureCode,
                                 for: systemId,
                                 and: endPointId)
    }
    open func utilityReportSystemFailure(sendDebug: Bool,
                                         debugString: String,
                                         result: WKRPTCLSystemsData.Result = .failure,
                                         and failureCode: String,
                                         for systemId: String,
                                         and endPointId: String) {
        self.utilityReportSystem(debugString: sendDebug ? debugString : "",
                                 result: result,
                                 and: failureCode,
                                 for: systemId,
                                 and: endPointId)
    }
    open func utilityReportSystem(debugString: String,
                                  result: WKRPTCLSystemsData.Result,
                                  and failureCode: String,
                                  for systemId: String,
                                  and endPointId: String) {
        guard !systemId.isEmpty && !endPointId.isEmpty else { return }
        _ = self.wkrSystems?.doReport(result: result, and: failureCode,
                                      and: debugString, for: systemId,
                                      and: endPointId, with: nil)
    }
}
