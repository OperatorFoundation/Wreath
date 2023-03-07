//
//  WreathFrontendServer.swift
//
//
//  Created by Clockwork on Mar 6, 2023.
//

import Foundation

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
                    throw WreathServerError.readFailed
                }

                let decoder = JSONDecoder()
                let request = try decoder.decode(WreathRequest.self, from: requestData)
                switch request
                {
                    case .GettransportserverconfigsRequest(let value):
                        let result = try self.handler.getTransportServerConfigs(transportName: value.transportName, clientID: value.clientID)
                        let response = try WreathResponse.GettransportserverconfigsResponse(result)
                        let encoder = JSONEncoder()
                        let responseData = try encoder.encode(response)
                        guard connection.writeWithLengthPrefix(data: responseData, prefixSizeInBits: 64) else
                        {
                            throw WreathServerError.writeFailed
                        }
                    case .GetwreathserversRequest(let value):
                        let result = try self.handler.getWreathServers(clientID: value.clientID)
                        let response = try WreathResponse.GetwreathserversResponse(result)
                        let encoder = JSONEncoder()
                        let responseData = try encoder.encode(response)
                        guard connection.writeWithLengthPrefix(data: responseData, prefixSizeInBits: 64) else
                        {
                            throw WreathServerError.writeFailed
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

public enum WreathServerError: Error
{
    case connectionRefused(String, Int)
    case writeFailed
    case readFailed
    case badReturnType
}
