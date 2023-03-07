//
//  WreathState.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/7/23.
//

import Foundation

import Abacus
import Wreath

public class WreathState
{
    public var configs: Set<TransportConfig> = Set<TransportConfig>()

    public init() throws
    {
    }

    public func add(config: TransportConfig)
    {
        self.configs.insert(config)
    }

    public func remove(config: TransportConfig)
    {
        self.remove(config: config)
    }
}
