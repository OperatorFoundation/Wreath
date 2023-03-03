//
//  BootstrapCommunicator.swift
//  
//
//  Created by Mafalda on 2/14/23.
//

import Foundation

import Antiphony
import Arcadia
import Transmission
import WreathBootstrapClient
import Gardener
import Keychain

class BootstrapCommunicator
{
    let wreathBootstrapClient: WreathBootstrapClient
    let config: ClientConfig
    let serverID:  ArcadiaID
    let wreathBootstrapClientConfigFilename = "bootstrap-client.json"
    
    //TODO: Add a timer for send heartbeat
    
    init(config: ClientConfig, connection: TransmissionTypes.Connection) throws
    {
        guard let arcadiaID = config.serverPublicKey.arcadiaID else
        {
            throw AntiphonyError.invalidConfigFile
        }
        
        self.serverID = arcadiaID
        self.wreathBootstrapClient = WreathBootstrapClient(connection: connection)
        self.config = config
    }
    
    convenience init(configURL: URL) throws
    {
        guard let config = ClientConfig(url: configURL) else
        {
            throw AntiphonyError.invalidConfigFile
        }
        
        guard let connection = TransmissionConnection(host: config.host, port: config.port) else
        {
            throw AntiphonyError.failedToCreateConnection
        }
                
        try self.init(config: config, connection: connection)
    }
    
    convenience init() throws
    {
        let configURL = File.homeDirectory().appendingPathComponent("Bootstrap-client.json")
        try self.init(configURL: configURL)
    }
    
    func findPeers() throws -> [WreathServerInfo]
    {
        // Gets a list of other wreath servers
        let listOfOtherWreathServers = try wreathBootstrapClient.getAddresses(serverID: self.serverID)
        
        print("Received a list of peers from the bootstrap server:")
        for wreathServer in listOfOtherWreathServers
        {
            print(wreathServer)
        }
        
        return listOfOtherWreathServers
    }
    
    /// Registers the provided wreath server with the bootstrap server
    func registerNewAddress() throws
    {
        print("Registering new address...")
        let serverInfo = WreathServerInfo(publicKey: config.serverPublicKey, serverAddress: "\(config.host):\(config.port)")
        try wreathBootstrapClient.registerNewAddress(newServer: serverInfo)
        print("New address registered!")
    }
    
    /// A keepalive function that lets the Bootstrap server know that the given wreath server is still active
    func sendHeartbeat() throws
    {
        print("Sending heartbeat...")
        try wreathBootstrapClient.sendHeartbeat(serverID: self.serverID)
        print("Heartbeat sent!")
    }
}
