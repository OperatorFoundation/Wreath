//
//  BootstrapCommunicator.swift
//  
//
//  Created by Mafalda on 2/14/23.
//

import Foundation

import Arcadia
import WreathBootstrapClient
import Gardener
import TransmissionTypes

class BootstrapCommunicator
{
    let wreathBootstrapClient: WreathBootstrapClient
    let serverID: String
    let serverIDKey: Key
    let serverIP: String
    let serverPort: Int
    let wreathBootstrapClientConfigFilename = "bootstrap-client.json"
    
    //TODO: Add a timer for send heartbeat
    
    init(serverID: String, serverIDKey: Key, serverIP: String, serverPort: Int, connection: TransmissionTypes.Connection)
    {
        self.wreathBootstrapClient = WreathBootstrapClient(connection: connection)
        self.serverIDKey = serverIDKey
        self.serverID = serverID
        self.serverIP = serverIP
        self.serverPort = serverPort
    }
    
    func someThingsThatBootstrapClientsDo() throws
    {
        // TODO: Make a test for this and break it out into its own function.
        // Gets a list of other wreath servers
        let listOfOtherWreathServers = try wreathBootstrapClient.getAddresses(serverID: self.serverID)
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
        let configURL = File.homeDirectory().appendingPathComponent(wreathBootstrapClientConfigFilename)
        let client = try WreathBootstrapClient(configURL: configURL)
        let serverInfo = WreathServerInfo(key: serverIDKey, serverAddress: "\(serverIP):\(serverPort)")
        try client.registerNewAddress(newServer: serverInfo)
        print("New address registered!")
    }
    
    /// A keepalive function that lets the Bootstrap server know that the given wreath server is still active
    func sendHeartbeat() throws
    {
        print("Sending heartbeat...")
        let configURL = File.homeDirectory().appendingPathComponent(wreathBootstrapClientConfigFilename)
        let client = try WreathBootstrapClient(configURL: configURL)
        try client.sendHeartbeat(serverID: self.serverID)
        print("Heartbeat sent!")
    }
}
