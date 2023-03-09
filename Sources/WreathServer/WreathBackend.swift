//
//  Wreath.swift
//  Wreath
//
//  Created by Joseph Bragel on 2/8/23.
//

import Foundation

import Antiphony
import Arcadia
import ShadowSwift
import Wreath
import KeychainTypes

public class WreathBackend
{
    let state: WreathState

    init(state: WreathState) throws
    {
        self.state = state
    }

    public func addTransportServerConfig(config: TransportConfig)
    {
        self.state.add(config: config)
    }

    public func removeTransportServerConfig(config: TransportConfig)
    {
        print("-> removeTransportServerConfig()")
        self.state.remove(config: config)
        print("-> removeTransportServerConfig() FINISHED")
    }
}
