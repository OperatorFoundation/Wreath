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
        let timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.communicator.sendHeartbeat), userInfo: nil, repeats: true)
        timer.tolerance = 2.0
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
