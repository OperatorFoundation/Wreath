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

public class WreathFrontend
{
    let state: WreathState
    let communicator: BootstrapCommunicator
    
    init(state: WreathState) throws
    {
        self.state = state

        self.communicator = try BootstrapCommunicator()
    }
    
    public func getTransportServerConfigs(transportName: String, clientID: String) throws -> [TransportConfig]
    {
        let allConfigs = self.state.getConfigs()
        return allConfigs.filter
        {
            config in

            switch config
            {
                case .shadow(_):
                    return transportName == "shadow"
            }
        }
    }
    
    public func getWreathServers(clientID: String) throws -> [WreathServerInfo]
    {
        return try communicator.findPeers()
    }
}
