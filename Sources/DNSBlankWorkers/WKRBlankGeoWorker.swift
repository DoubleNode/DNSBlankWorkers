//
//  WKRBlankGeoWorker.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import DNSProtocols
import Foundation

open class WKRBlankGeoWorker: WKRBlankBaseWorker, WKRPTCLGeo {
    public var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    public var nextWorker: WKRPTCLGeo?

    public required init() {
        super.init()
        wkrSystems = WKRBlankSystemsWorker()
    }
    public func register(nextWorker: WKRPTCLGeo,
                         for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.callNextWhen = callNextWhen
        self.nextWorker = nextWorker
    }

    override open func disableOption(_ option: String) {
        super.disableOption(option)
        nextWorker?.disableOption(option)
    }
    override open func enableOption(_ option: String) {
        super.enableOption(option)
        nextWorker?.enableOption(option)
    }
    @discardableResult
    public func runDo(runNext: DNSPTCLCallBlock?,
                      doWork: DNSPTCLCallResultBlock = { return $0?(.unhandled) }) -> Any? {
        let runNext = (self.nextWorker != nil) ? runNext : nil
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
                         and block: WKRPTCLGeoBlkString?) {
        self.runDo(runNext: {
            return self.nextWorker?.doLocate(with: progress, and: block)
        },
        doWork: {
            return self.intDoLocate(with: progress, and: block, then: $0)
        })
    }
    public func doTrackLocation(for processKey: String,
                                with progress: DNSPTCLProgressBlock?,
                                and block: WKRPTCLGeoBlkString?) {
        self.runDo(runNext: {
            return self.nextWorker?.doTrackLocation(for: processKey, with: progress, and: block)
        },
        doWork: {
            return self.intDoTrackLocation(for: processKey, with: progress, and: block, then: $0)
        })
    }
    public func doStopTrackLocation(for processKey: String) -> WKRPTCLGeoResVoid {
        return self.runDo(runNext: {
            return self.nextWorker?.doStopTrackLocation(for: processKey)
        },
        doWork: {
            return self.intDoStopTrackLocation(for: processKey, then: $0)
        }) as! WKRPTCLGeoResVoid // swiftlint:disable:this force_cast
    }

    // MARK: - Worker Logic (Shortcuts) -
    public func doLocate(with block: WKRPTCLGeoBlkString?) {
        self.doLocate(with: nil, and: block)
    }
    public func doTrackLocation(for processKey: String,
                                with block: WKRPTCLGeoBlkString?) {
        self.doTrackLocation(for: processKey, with: nil, and: block)
    }

    // MARK: - Internal Work Methods
    open func intDoLocate(with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLGeoBlkString?,
                          then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoTrackLocation(for processKey: String,
                                 with progress: DNSPTCLProgressBlock?,
                                 and block: WKRPTCLGeoBlkString?,
                                 then resultBlock: DNSPTCLResultBlock?) {
        _ = resultBlock?(.unhandled)
    }
    open func intDoStopTrackLocation(for processKey: String,
                                     then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLGeoResVoid {
        _ = resultBlock?(.unhandled)
        return .success
    }
}
