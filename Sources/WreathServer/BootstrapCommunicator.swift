//
//  BootstrapCommunicator.swift
//  
//
//  Created by Mafalda on 2/14/23.
//

import Foundation

import Arcadia
import BootstrapClient
import TransmissionTypes

class BootstrapCommunicator
{
    let bootstrapClient: BootstrapClient
    
    init(connection: TransmissionTypes.Connection)
    {
        self.bootstrapClient = BootstrapClient(connection: connection)
    }
    
    func someThingsThatBootstrapClientsDo() throws
    {
        // Gets a list of other wreath servers
        let listOfOtherWreathServers = try bootstrapClient.getAddresses(serverID: "fakeserverID")
        print("Received a list of peers from the bootstrap server:")
        for wreathServer in listOfOtherWreathServers
        {
            print(wreathServer)
        }

        // Registers the provided wreath server with the bootstrap server
        let wreathServerInformation = WreathServerInfo(serverID: "fakeserverid", serverAddress: "someaddress")
        try bootstrapClient.registerNewAddress(newServer: wreathServerInformation)


         // A keepalive function that lets the Bootstrap server know that the given wreath server is still active
        try bootstrapClient.sendHeartbeat(serverID: "fakeServerID")
    }
}
