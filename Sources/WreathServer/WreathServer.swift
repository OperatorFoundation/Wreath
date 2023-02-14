//
//  WreathServer.swift
//
//
//  Created by Clockwork on Feb 14, 2023.
//

import Foundation

import TransmissionTypes
import Wreath

public class WreathServer
{
    let listener: TransmissionTypes.Listener
    let handler: Wreath

    var running: Bool = true

    public init(listener: TransmissionTypes.Listener, handler: Wreath)
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
                    case .getTransportServerConfig(let value):
                        let result = try self.handler.getTransportServerConfig(transportName: value.transportName, clientID: value.clientID)
                        let response = try WreathResponse.getTransportServerConfig(result)
                        let encoder = JSONEncoder()
                        let responseData = try encoder.encode(response)
                        guard connection.writeWithLengthPrefix(data: responseData, prefixSizeInBits: 64) else
                        {
                            throw WreathServerError.writeFailed
                        }
                    case .getWreathServer(let value):
                        let result = try self.handler.getWreathServer(clientID: value.clientID)
                        let response = try WreathResponse.getWreathServer(result)
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
