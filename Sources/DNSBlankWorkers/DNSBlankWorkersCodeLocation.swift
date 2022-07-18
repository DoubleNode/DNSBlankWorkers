//
//  DNSBlankWorkersCodeLocation.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError

public extension DNSCodeLocation {
    typealias blankWorkers = DNSBlankWorkersCodeLocation
}
open class DNSBlankWorkersCodeLocation: DNSCodeLocation {
    override open class var domainPreface: String { "com.doublenode.blankWorkers." }
}
