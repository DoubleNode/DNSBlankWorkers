//
//  WKRBlankActivities.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import DNSError
import DNSProtocols
import Foundation

open class WKRBlankActivities: WKRBaseActivities {
    // MARK: - Internal Work Methods
    override open func intDoLoadActivities(for place: DAOPlace,
                                  using activityTypes: [DAOActivityType],
                                  with progress: DNSPTCLProgressBlock?,
                                  and block: WKRPTCLActivitiesBlkAActivity?,
                                  then resultBlock: DNSPTCLResultBlock?) {
        block?(.success([]))
        _ = resultBlock?(.completed)
    }
    override open func intDoUpdate(_ activities: [DAOActivity],
                          for place: DAOPlace,
                          with progress: DNSPTCLProgressBlock?,
                          and block: WKRPTCLActivitiesBlkVoid?,
                          then resultBlock: DNSPTCLResultBlock?) {
        block?(.success)
        _ = resultBlock?(.completed)
    }
}
