//
//  Wreath.swift
//  Wreath
//
//  Created by Joseph Bragel on 2/8/23.
//

import Foundation

import Antiphony
import Arcadia
import Datable
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
    
    public func getTransportServerConfigs(transportName: String, clientID: String) -> [TransportConfig]
    {
        let decoder = JSONDecoder()
        
        do
        {
            let arcadiaID = try decoder.decode(ArcadiaID.self, from: clientID.data)

            return self.state.getConfigs(transportName: transportName, clientID: arcadiaID)
        }
        catch
        {
            print("getTransportServerConfigs error: \(error)")
            return []
        }
        
    }
    
    public func getWreathServers(clientID: String) -> [WreathServerInfo]
    {
        do
        {
            return try communicator.findPeers()
        }
        catch
        {
            print("getWreathServers error: \(error)")
            return []
        }
        
    }
}
