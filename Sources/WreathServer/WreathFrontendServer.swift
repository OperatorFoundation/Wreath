//
//  WreathFrontendServer.swift
//
//
//  Created by Clockwork on Mar 8, 2023.
//

import Foundation

import Arcadia
import TransmissionTypes
import Wreath

public class WreathFrontendServer
{
    let listener: TransmissionTypes.Listener
    let handler: WreathFrontend

    var running: Bool = true

    public init(listener: TransmissionTypes.Listener, handler: WreathFrontend)
    {
        self.listener = listener
        self.handler = handler

        Task
        {
            self.acceptLoop()
        }
    }

    public func shutdown()
    {
        self.running = false
    }

    func acceptLoop()
    {
        while self.running
        {
            do
            {
                let connection = try self.listener.accept()

                Task
                {
                    self.handleConnection(connection)
                }
            }
            catch
            {
                print(error)
                self.running = false
                return
            }
        }
    }

    func handleConnection(_ connection: TransmissionTypes.Connection)
    {
        while self.running
        {
            do
            {
                guard let requestData = connection.readWithLengthPrefix(prefixSizeInBits: 64) else
                {
                    throw WreathFrontendServerError.readFailed
                }

                let decoder = JSONDecoder()
                let request = try decoder.decode(WreathFrontendRequest.self, from: requestData)
                switch request
                {
                    case .GettransportserverconfigsRequest(let value):
                        let result = self.handler.getTransportServerConfigs(transportName: value.transportName, clientID: value.clientID)
                        let response = WreathFrontendResponse.GettransportserverconfigsResponse(result)
                        let encoder = JSONEncoder()
                        let responseData = try encoder.encode(response)
                        guard connection.writeWithLengthPrefix(data: responseData, prefixSizeInBits: 64) else
                        {
                            throw WreathFrontendServerError.writeFailed
                        }
                    case .GetwreathserversRequest(let value):
                        let result = self.handler.getWreathServers(clientID: value.clientID)
                        let response = WreathFrontendResponse.GetwreathserversResponse(result)
                        let encoder = JSONEncoder()
                        let responseData = try encoder.encode(response)
                        guard connection.writeWithLengthPrefix(data: responseData, prefixSizeInBits: 64) else
                        {
                            throw WreathFrontendServerError.writeFailed
                        }
                }
            }
            catch
            {
                print(error)
                return
            }
        }
    }
}

public enum WreathFrontendServerError: Error
{
    case connectionRefused(String, Int)
    case writeFailed
    case readFailed
    case badReturnType
}
