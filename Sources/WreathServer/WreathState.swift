//
//  WreathState.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/7/23.
//

import Foundation

import Wreath

public class WreathState
{
    public var configs: Set<TransportConfig> = Set<TransportConfig>()

    let lock = DispatchSemaphore(value: 1)

    public init() throws
    {
    }

    public func getConfigs() -> [TransportConfig]
    {
        defer
        {
            self.lock.signal()
        }
        self.lock.wait()

        return [TransportConfig](self.configs)
    }

    public func add(config: TransportConfig)
    {
        defer
        {
            self.lock.signal()
        }
        self.lock.wait()

        self.configs.insert(config)
    }

    public func remove(config: TransportConfig)
    {
        defer
        {
            self.lock.signal()
        }
        self.lock.wait()

        self.remove(config: config)
    }
}
