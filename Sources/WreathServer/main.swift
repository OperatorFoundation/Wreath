//
//  main.swift
//  Wreath
//
//  Created by Joseph Bragel on 2/8/23.
//

import ArgumentParser
import Foundation

import Antiphony
import Gardener
import Spacetime

struct WreathCommandLine: ParsableCommand
{
    static let configuration = CommandConfiguration(
        commandName: "WreathServer",
        subcommands: [New.self, Run.self]
    )
    
    static let clientConfigURL =  File.homeDirectory().appendingPathComponent("wreath-client.json")
    static let serverConfigURL = File.homeDirectory().appendingPathComponent("wreath-server.json")
    static let serverFrontendConfigURL = File.homeDirectory().appendingPathComponent("wreath-server-frontend.json")
    static let serverBackendConfigURL = File.homeDirectory().appendingPathComponent("wreath-server-backend.json")
    static let loggerLabel = "org.OperatorFoundation.WreathLogger"
}

extension WreathCommandLine
{
    struct New: ParsableCommand
    {
        @Argument(help: "Human-readable name for your server to use in invites")
        var name: String

        @Argument(help: "Port on which to run the server")
        var port: Int
        
        func run() throws {
            print("Running Wreath.new")
            let keychainDirectoryURL = File.homeDirectory().appendingPathComponent(".wreath-server")
            let keychainLabel = "Wreath.KeyAgreement"

            // FIXME
            try Antiphony.generateNew(name: name, port: port, serverConfigURL: serverFrontendConfigURL, clientConfigURL: clientConfigURL, keychainURL: keychainDirectoryURL, keychainLabel: keychainLabel)
        }
    }
}

extension WreathCommandLine
{
    struct Run: ParsableCommand
    {
        func run() throws
        {
            print("Running Wreath.run")

            let state = try WreathState()

            let antiphonyFrontend = try Antiphony(serverConfigURL: serverFrontendConfigURL, loggerLabel: loggerLabel, capabilities: Capabilities(.display, .networkListen))
            
            guard let antiphonyFrontendListener = antiphonyFrontend.listener else
            {
                print("Failed to create a frontend listener")
                return
            }

            let wreathFrontendLogic = try WreathFrontend(state: state)
            let _ = WreathFrontendServer(listener: antiphonyListener, handler: wreathFrontendLogic)
            
            antiphony.wait()
        }
    }
}

WreathCommandLine.main()

