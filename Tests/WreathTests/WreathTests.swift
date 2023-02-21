import XCTest

@testable import Wreath
@testable import WreathServer

import Antiphony
import Arcadia
import BootstrapClient
import Gardener
import TransmissionTypes

final class WreathTests: XCTestCase {
    
    
    func testRegisterNewAddress() throws
    {
        print("Test registering new address...")
        let configURL = File.homeDirectory().appendingPathComponent("bootstrap-client.json")
        let client = try BootstrapClient(configURL: configURL)
        let serverInfo = WreathServerInfo(serverID: "thisisnotarealid", serverAddress: "127.0.0.1:1234")
        try client.registerNewAddress(newServer: serverInfo)
        print("Test complete!")
    }
    
    func testHeartbeat() throws
    {
        print("Testing heartbeat...")
        let configURL = File.homeDirectory().appendingPathComponent("bootstrap-client.json")
        let client = try BootstrapClient(configURL: configURL)
        try client.sendHeartbeat(serverID: "thisisnotarealid")
        print("Test complete!")
    }
}
