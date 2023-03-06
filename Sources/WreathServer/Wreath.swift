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

public class Wreath
{
    let communicator: BootstrapCommunicator
    
    init() throws
    {
        communicator = try BootstrapCommunicator()
    }
    
    public func getTransportServerConfigs(transportName: String, clientID: String) throws -> [TransportConfig]
    {
        // FIXME: This is just a demo until communications channel work is complete
        let privateKeyString = "RaHouPFVOazVSqInoMm8BSO9o/7J493y4cUVofmwXAU="
        
        guard let privateKeyBytes = Data(base64: privateKeyString) else
        {
            throw KeyError.publicKeySerializationFailed
        }
        guard let privateKey = try? PrivateKey(type: .P256KeyAgreement, data: privateKeyBytes) else
        {
            throw KeyError.publicKeySerializationFailed
        }
        
        let publicKey = privateKey.publicKey
        let shadowConfig = ShadowConfig.ShadowClientConfig(serverAddress: "8.8.8.8", serverPublicKey: publicKey, mode: .DARKSTAR)
        let demoTransportConfig = TransportConfig.shadow(shadowConfig)
        
        return [demoTransportConfig]
    }
    
    public func getWreathServers(clientID: String) throws -> [WreathServerInfo]
    {
        return try communicator.findPeers()
    }
}
