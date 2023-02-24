import XCTest

@testable import Wreath
@testable import WreathServer

import Antiphony
import Arcadia
import Gardener
import Keychain
import KeychainTypes
import TransmissionTypes
import WreathBootstrapClient

final class WreathTests: XCTestCase {
    
    
    func testRegisterNewAddress() throws
    {
        print("Test registering new address...")
        let configURL = File.homeDirectory().appendingPathComponent("bootstrap-client.json")
        let client = try WreathBootstrapClient(configURL: configURL)
//        let serverIDKey = Key(data: "exampleServerKey")
        let serverIDKey = try PublicKey(string: "examplePublicKey")
        let serverInfo = WreathServerInfo(publicKey: serverIDKey, serverAddress: "127.0.0.1:1234")
        try client.registerNewAddress(newServer: serverInfo)
        print("Test complete!")
    }
    
    func testHeartbeat() throws
    {
        print("Testing heartbeat...")
        let configURL = File.homeDirectory().appendingPathComponent("bootstrap-client.json")
        let client = try WreathBootstrapClient(configURL: configURL)
//        try client.sendHeartbeat(serverID: "thisisnotarealid")
        let serverID = try PublicKey(string: "examplePublicKey")
        let serverIDKey = try Key(publicKey: serverID)
        try client.sendHeartbeat(key: serverIDKey)
        print("Test complete!")
    }
}
