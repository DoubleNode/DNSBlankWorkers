//
//  WKRBlankPlaces.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCore
import DNSDataObjects
import DNSDataTypes
import DNSError
import DNSProtocols

open class WKRBlankPlaces: WKRBasePlaces {
    // MARK: - Internal Work Methods
    override open func intDoFilterPlaces(for activity: DAOActivity,
                                         using places: [DAOPlace],
                                         with progress: DNSPTCLProgressBlock?,
                                         and block: WKRPTCLPlacesBlkAPlace?,
                                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadHolidays(for place: DAOPlace,
                                         with progress: DNSPTCLProgressBlock?,
                                         and block: WKRPTCLPlacesBlkAPlaceHoliday?,
                                         then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadHours(for place: DAOPlace,
                                      with progress: DNSPTCLProgressBlock?,
                                      and block: WKRPTCLPlacesBlkPlaceHours?,
                                      then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOPlaceHours()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadPlace(for placeCode: String,
                                      with progress: DNSPTCLProgressBlock?,
                                      and block: WKRPTCLPlacesBlkPlace?,
                                      then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOPlace()))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadPlaces(with progress: DNSPTCLProgressBlock?,
                                       and block: WKRPTCLPlacesBlkAPlace?,
                                       then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadPlaces(for account: DAOAccount,
                                       with progress: DNSPTCLProgressBlock?,
                                       and block: WKRPTCLPlacesBlkAPlace?,
                                       then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadPlaces(for section: DAOSection,
                                       with progress: DNSPTCLProgressBlock?,
                                       and block: WKRPTCLPlacesBlkAPlace?,
                                       then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoLoadState(for place: DAOPlace,
                                      with progress: DNSPTCLProgressBlock?,
                                      then resultBlock: DNSPTCLResultBlock?) -> WKRPTCLPlacesPubAlertEventStatus {
        _ = resultBlock?(.completed)
        return WKRPTCLPlacesFutAlertEventStatus { $0(.success(([], [], []))) }.eraseToAnyPublisher()
    }
    override open func intDoReact(with reaction: DNSReactionType,
                                  to place: DAOPlace,
                                  with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLPlacesBlkMeta?,
                                  then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoSearchPlace(for geohash: String,
                                        with progress: DNSPTCLProgressBlock?,
                                        and block: WKRPTCLPlacesBlkPlace?,
                                        then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DAOPlace()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUnreact(with reaction: DNSReactionType,
                                    to place: DAOPlace,
                                    with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLPlacesBlkMeta?,
                                    then resultBlock: DNSPTCLResultBlock?) {
        block?(.success(DNSMetadata()))
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ place: DAOPlace,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLPlacesBlkVoid?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ hours: DAOPlaceHours,
                                   for place: DAOPlace,
                                   with progress: DNSPTCLProgressBlock?,
                                   and block: WKRPTCLPlacesBlkVoid?,
                                   then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
