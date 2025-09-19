//
//  WKRBase.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Alamofire
import AtomicSwift
import DNSBlankNetwork
import DNSCore
import DNSCrashNetwork
import DNSDataObjects
import DNSProtocols
import Foundation

public typealias WKRPTCLBaseResponseErrorString = String

public struct WKRPTCLBaseResponseErrorStruct: Codable {
    let code: Int
    let message: String
}
public extension WKRPTCLBaseResponseErrorStruct {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(Int.self, forKey: .code)
        message = try container.decode(String.self, forKey: .message)
    }
}
public enum WKRPTCLBaseResponseError<L, R> {
    case string(L)
    case `struct`(R)
}
// moving Codable requirement conformance to extension
extension WKRPTCLBaseResponseError: Codable where L: Codable, R: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            // first try to decode as left type
            self = try .string(container.decode(L.self))
        } catch {
            do {
                // if the decode fails try to decode as right type
                self = try .struct(container.decode(R.self))
            } catch {
                // both of the types failed? throw type mismatch error
                throw DecodingError.typeMismatch(WKRPTCLBaseResponseError.self,
                                   .init(codingPath: decoder.codingPath,
                                         debugDescription: "Expected either \(L.self) or \(R.self)",
                                         underlyingError: error))
            }
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .string(value):
            try container.encode(value)
        case let .struct(value):
            try container.encode(value)
        }
    }
}

public protocol WKRPTCLBaseResponse: Decodable {
    var error: WKRPTCLBaseResponseError<WKRPTCLBaseResponseErrorString, WKRPTCLBaseResponseErrorStruct>? { get }
    var message: String? { get }
}

open class WKRBase: NSObject, WKRPTCLWorkerBase {
    public static var xlt = DNSDataTranslation()

    static public var languageCode: String {
        DNSCore.languageCode
    }

    @Atomic
    private var options: [String] = []

    public var netConfig: NETPTCLConfig {
        get { return NETBlankConfig() }
        set { /* Default implementation ignores setter */ }
    }
    public var netRouter: NETPTCLRouter {
        get { return NETBlankRouter() }
        set { /* Default implementation ignores setter */ }
    }

    // MARK: - DNSPTCLWorker requirements
    public var nextWorker: DNSPTCLWorker?

    // MARK: - WKRPTCLWorkerBase requirements
    open var wkrSystems: WKRPTCLSystems?
    
    override public required init() {
        super.init()
    }
    open func configure() { }
    
    public func checkOption(_ option: String) -> Bool {
        return self.options.contains(option)
    }
    open func enableOption(_ option: String) {
        guard !self.checkOption(option) else { return }
        self.options.append(option)
    }
    open func disableOption(_ option: String) {
        self.options.removeAll { $0 == option }
    }
    
    // MARK: - UIWindowSceneDelegate methods
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    open func didBecomeActive() { }
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    open func willResignActive() { }
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    open func willEnterForeground() { }
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    open func didEnterBackground() { }
    
    open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                   with error: Error) -> DNSPTCLWorker.Call.Result {
        return result
    }
    open func runDo(callNextWhen: DNSPTCLWorker.Call.NextWhen,
                    runNext: DNSPTCLCallBlock?,
                    doWork: DNSPTCLCallResultBlock) -> Any? {
        let resultBlock: DNSPTCLResultBlock = { result in
            var result = result
            if case .failure(let error) = result {
                result = self.confirmFailureResult(result, with: error)
            }
            switch result {
            case .completed:
                guard [.always].contains(where: { $0 == callNextWhen }) else { return nil }
            case .error, .failure:
                guard [.always, .whenError].contains(where: { $0 == callNextWhen }) else { return nil }
            case .notFound:
                guard [.always, .whenNotFound].contains(where: { $0 == callNextWhen }) else { return nil }
            case .unhandled:
//                guard [.always, .whenUnhandled].contains(where: { $0 == callNextWhen }) else { return nil }
                break
            }
            return runNext?()
        }
        return doWork(resultBlock)
    }
    
    // MARK: - Worker Logic (Public) -
    open func doAnalytics(for object: DAOBaseObject,
                          using data: DNSDataDictionary,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLWorkerBaseBlkAAnalyticsData?) { }
    
    // MARK: - Worker Logic (Shortcuts) -
    public func doAnalytics(for object: DAOBaseObject,
                            using data: DNSDataDictionary,
                            and block: WKRPTCLWorkerBaseBlkAAnalyticsData?) {
        self.doAnalytics(for: object, using: data, with: nil, and: block)
    }
    
    // MARK: - Internal Work Methods
    open func intDoAnalytics(for object: DAOBaseObject,
                             using data: DNSDataDictionary,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLWorkerBaseBlkAAnalyticsData?,
                             then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.completed)
    }
}
