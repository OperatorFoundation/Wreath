import XCTest

@testable import Wreath
@testable import WreathClient
@testable import WreathServer

import Antiphony
import Arcadia
import Gardener
import Keychain
import KeychainTypes
import ShadowSwift
import Transmission
import WreathBootstrapClient

final class WreathTests: XCTestCase
{
    
    func startBootstrapClient() throws -> (client: WreathBootstrapClient, clientConfig: ClientConfig)
    {
        let configURL = File.homeDirectory().appendingPathComponent("Bootstrap-client.json")
        
        guard let config = ClientConfig(url: configURL) else
        {
            throw AntiphonyError.invalidConfigFile
        }
        
        guard let connection = TransmissionConnection(host: config.host, port: config.port) else
        {
            throw AntiphonyError.failedToCreateConnection
        }
        
        let client = WreathBootstrapClient(connection: connection)
        
        return (client, config)
    }
        
    func testBootstrapCommunicatorRegisterNewAddress() throws
    {
        let communicator = try BootstrapCommunicator()
        try communicator.registerNewAddress()
    }
    
    func testBootstrapCommunicatorSendHeartbeat() throws
    {
        let communicator = try BootstrapCommunicator()
        try communicator.sendHeartbeat()
    }
    
    /// Note: This will return an empty array if you have not registered more than one server with this instance of the Bootstrap server
    func testBootstrapClientGetAddresses() throws
    {
        let communicator = try BootstrapCommunicator()
        let wreathServers = try communicator.findPeers()
        print("Received a GetAddresses response from the server: \(wreathServers)")
    }
    
    func startBackendClient() throws -> (client: WreathBackendClient, clientConfig: ClientConfig)
    {
        let configURL = File.homeDirectory().appendingPathComponent("wreath-client-backend.json")
        
        guard let config = ClientConfig(url: configURL) else
        {
            throw AntiphonyError.invalidConfigFile
        }
        
        guard let connection = TransmissionConnection(host: config.host, port: config.port) else
        {
            throw AntiphonyError.failedToCreateConnection
        }
        
        let client = WreathBackendClient(connection: connection)
        
        return (client, config)
    }
    
    func testBackendClient() throws
    {
        let (wreathBackendClient, _) = try startBackendClient()
        let configURL = File.homeDirectory().appendingPathComponent("ShadowClientConfig.json")
        
        guard let shadowConfig = ShadowConfig.ShadowClientConfig(path: configURL.path) else
        {
            throw AntiphonyError.invalidConfigFile
        }
        
        let transportConfig = TransportConfig.shadow(shadowConfig)
        try wreathBackendClient.addTransportServerConfig(config: transportConfig)
        try wreathBackendClient.removeTransportServerConfig(config: transportConfig)
    }
    
}

public enum WreathTestsError: Error
{
    case failedToCreateServerID
}
