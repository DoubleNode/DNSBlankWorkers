//
//  WKRBlankGeo.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import DNSCore
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankGeo: WKRBlankBase, WKRPTCLGeo {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled

    public var nextWKRPTCLGeo: WKRPTCLGeo? {
        get { return nextWorker as? WKRPTCLGeo }
        set { nextWorker = newValue }
    }

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystems()
    }
    public func register(nextWorker: WKRPTCLGeo,
                         for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.callNextWhen = callNextWhen
        self.nextWKRPTCLGeo = nextWorker
    }

    override open func disableOption(_ option: String) {
        super.disableOption(option)
        nextWKRPTCLGeo?.disableOption(option)
    }
    override open func enableOption(_ option: String) {
        super.enableOption(option)
        nextWKRPTCLGeo?.enableOption(option)
    }
    @discardableResult
    public func runDo(runNext: DNSPTCLCallBlock?,
                      doWork: DNSPTCLCallResultBlock = { return $0?(.completed) }) -> Any? {
        let runNext = (self.nextWKRPTCLGeo != nil) ? runNext : nil
        return self.runDo(callNextWhen: self.callNextWhen, runNext: runNext, doWork: doWork)
    }
    override open func confirmFailureResult(_ result: DNSPTCLWorker.Call.Result,
                                            with error: Error) -> DNSPTCLWorker.Call.Result {
        if case DNSError.Geo.notFound = error {
            return .notFound
        }
        return result
    }

    // MARK: - Worker Logic (Public) -
    public func doLocate(with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLGeoBlkStringLocation?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLGeo?.doLocate(with: progress, and: block)
        },
                   doWork: {
            return self.intDoLocate(with: progress, and: block, then: $0)
        })
    }
    public func doLocate(_ address: DNSPostalAddress,
                         with progress: DNSPTCLProgressBlock?,
                         and block: WKRPTCLGeoBlkStringLocation?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLGeo?.doLocate(address, with: progress, and: block)
        },
                   doWork: {
            return self.intDoLocate(address, with: progress, and: block, then: $0)
        })
    }
    public func doTrackLocation(for processKey: String,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLGeoBlkStringLocation?) {
        self.runDo(runNext: {
            return self.nextWKRPTCLGeo?.doTrackLocation(for: processKey, with: progress, and: block)
        },
                   doWork: {
            return self.intDoTrackLocation(for: processKey, with: progress, and: block, then: $0)
        })
    }
    public func doStopTrackLocation(for processKey: String) -> WKRPTCLGeoResVoid {
        return self.runDo(runNext: {
            return self.nextWKRPTCLGeo?.doStopTrackLocation(for: processKey)
        },
                          doWork: {
            return self.intDoStopTrackLocation(for: processKey, then: $0)
        }) as! WKRPTCLGeoResVoid // swiftlint:disable:this force_cast
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLocate(with block: WKRPTCLGeoBlkStringLocation?) {
        self.doLocate(with: nil, and: block)
    }
    public func doLocate(_ address: DNSPostalAddress,
                         with block: WKRPTCLGeoBlkStringLocation?) {
        self.doLocate(address, with: nil, and: block)
    }
    public func doTrackLocation(for processKey: String,
                                with block: WKRPTCLGeoBlkStringLocation?) {
        self.doTrackLocation(for: processKey, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLocate(with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLGeoBlkStringLocation?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(("", CLLocation(from: DNSDataDictionary()))))
        _ = resultBlock?(.completed)
    }
    open func intDoLocate(_ address: DNSPostalAddress,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLGeoBlkStringLocation?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(("", CLLocation(from: DNSDataDictionary()))))
        _ = resultBlock?(.completed)
    }
    open func intDoTrackLocation(for processKey: String,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLGeoBlkStringLocation?,
                                 then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(("", CLLocation(from: DNSDataDictionary()))))
        _ = resultBlock?(.completed)
    }
    open func intDoStopTrackLocation(for processKey: String,
                                     then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLGeoResVoid {
        _ = resultBlock?(.completed)
        return .success
    }
}
