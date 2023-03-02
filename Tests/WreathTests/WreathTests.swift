import XCTest

@testable import Wreath
@testable import WreathServer

import Antiphony
import Arcadia
import Gardener
import Keychain
import KeychainTypes
import Transmission
import WreathBootstrapClient

final class WreathTests: XCTestCase {
    
    
    func testRegisterNewAddress() throws
    {
        print("Test registering new address...")
        let configURL = File.homeDirectory().appendingPathComponent("bootstrap-client.json")
        
        guard let clientConfig = ClientConfig(url: configURL) else
        {
            throw AntiphonyError.invalidConfigFile
        }
        
        guard let connection = TransmissionConnection(host: clientConfig.host, port: clientConfig.port) else
        {
            throw AntiphonyError.failedToCreateConnection
        }
        
        let client = WreathBootstrapClient(connection: connection)
                
        let serverInfo = WreathServerInfo(publicKey: clientConfig.serverPublicKey, serverAddress: "\(clientConfig.host):\(clientConfig.port)")
        try client.registerNewAddress(newServer: serverInfo)
        print("Test complete!")
    }
    
    func testHeartbeat() throws
    {
        print("Testing heartbeat...")
        let configURL = File.homeDirectory().appendingPathComponent("bootstrap-client.json")
        
        guard let clientConfig = ClientConfig(url: configURL) else
        {
            throw AntiphonyError.invalidConfigFile
        }
        
        guard let connection = TransmissionConnection(host: clientConfig.host, port: clientConfig.port) else
        {
            throw AntiphonyError.failedToCreateConnection
        }
        
        let client = WreathBootstrapClient(connection: connection)
                
        let serverInfo = WreathServerInfo(publicKey: clientConfig.serverPublicKey, serverAddress: "\(clientConfig.host):\(clientConfig.port)")
        try client.registerNewAddress(newServer: serverInfo)
        
        guard let serverID = clientConfig.serverPublicKey.arcadiaID else
        {
            throw WreathTestsError.failedToCreateServerID
        }
        
        try client.sendHeartbeat(serverID: serverID)
        print("Test complete!")
    }
}

public enum WreathTestsError: Error
{
    case failedToCreateServerID
}
