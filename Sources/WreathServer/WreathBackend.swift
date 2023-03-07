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
    let communicator: BootstrapCommunicator

    init(state: WreathState) throws
    {
        self.state = state

        self.communicator = try BootstrapCommunicator()
    }

    public func addTransportServerConfig(config: TransportConfig)
    {
        self.state.add(config: config)
    }

    public func removeTransportServerConfig(config: TransportConfig)
    {
        self.state.remove(config: config)
    }
}
