//
//  BootstrapCommunicator.swift
//  
//
//  Created by Mafalda on 2/14/23.
//

import Foundation

import Arcadia
import BootstrapClient
import Gardener
import TransmissionTypes

class BootstrapCommunicator
{
    let bootstrapClient: BootstrapClient
    let serverID: String
    let serverIP: String
    let serverPort: Int
    let bootstrapClientConfigFilename = "bootstrap-client.json"
    
    //TODO: Add a timer for send heartbeat
    
    init(serverID: String, serverIP: String, serverPort: Int, connection: TransmissionTypes.Connection)
    {
        self.bootstrapClient = BootstrapClient(connection: connection)
        self.serverID = serverID
        self.serverIP = serverIP
        self.serverPort = serverPort
    }
    
    func someThingsThatBootstrapClientsDo() throws
    {
        // TODO: Make a test for this and break it out into its own function.
        // Gets a list of other wreath servers
        let listOfOtherWreathServers = try bootstrapClient.getAddresses(serverID: self.serverID)
        print("Received a list of peers from the bootstrap server:")
        for wreathServer in listOfOtherWreathServers
        {
            print(wreathServer)
        }
    }
    
    /// Registers the provided wreath server with the bootstrap server
    func registerNewAddress() throws
    {
        print("Registering new address...")
        let configURL = File.homeDirectory().appendingPathComponent(bootstrapClientConfigFilename)
        let client = try BootstrapClient(configURL: configURL)
        let serverInfo = WreathServerInfo(serverID: self.serverID, serverAddress: "\(serverIP):\(serverPort)")
        try client.registerNewAddress(newServer: serverInfo)
        print("New address registered!")
    }
    
    /// A keepalive function that lets the Bootstrap server know that the given wreath server is still active
    func sendHeartbeat() throws
    {
        print("Sending heartbeat...")
        let configURL = File.homeDirectory().appendingPathComponent(bootstrapClientConfigFilename)
        let client = try BootstrapClient(configURL: configURL)
        try client.sendHeartbeat(serverID: self.serverID)
        print("Heartbeat sent!")
    }
}
