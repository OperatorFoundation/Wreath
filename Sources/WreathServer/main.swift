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
    
    static let clientFrontendConfigURL =  File.homeDirectory().appendingPathComponent("wreath-client-frontend.json")
    static let clientBackendConfigURL =  File.homeDirectory().appendingPathComponent("wreath-client-backend.json")
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
        
        func run() throws
        {
            print("Running Wreath.new")
            let keychainDirectoryURL = File.homeDirectory().appendingPathComponent(".wreath-server")
            let keychainLabel = "Wreath.KeyAgreement"

            try Antiphony.generateNew(name: name, port: port, serverConfigURL: serverFrontendConfigURL, clientConfigURL: clientFrontendConfigURL, keychainURL: keychainDirectoryURL, keychainLabel: keychainLabel)

            guard let frontendServerConfig = ServerConfig(url: serverFrontendConfigURL) else
            {
                throw CommandLineError.frontendConfigNotFound
            }
            
            let backendServerConfig = ServerConfig(name: frontendServerConfig.name, host: frontendServerConfig.host, port: frontendServerConfig.port + 1)
            try backendServerConfig.save(to: serverBackendConfigURL)
            print("Wrote config to \(serverBackendConfigURL.path)")
            
            guard let frontendClientConfig = ClientConfig(url: clientFrontendConfigURL) else
            {
                throw CommandLineError.frontendConfigNotFound
            }
            
            let backendClientConfig = ClientConfig(name: frontendClientConfig.name, host: frontendClientConfig.host, port: frontendClientConfig.port + 1, serverPublicKey: frontendClientConfig.serverPublicKey)
            try backendClientConfig.save(to: clientBackendConfigURL)
            print("Wrote config to \(clientBackendConfigURL.path)")
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

            let server = try WreathServer(serverFrontendConfigURL: WreathCommandLine.serverFrontendConfigURL, serverBackendConfigURL: WreathCommandLine.serverBackendConfigURL, loggerLabel: WreathCommandLine.loggerLabel)
        }
    }
}

public enum CommandLineError: Error
{
    case badServerAddress(String)
    case frontendConfigNotFound
}

WreathCommandLine.main()

