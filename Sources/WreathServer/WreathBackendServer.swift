//
//  WreathBackendServer.swift
//
//
//  Created by Clockwork on Mar 8, 2023.
//

import Foundation

import Arcadia
import TransmissionTypes
import Wreath

public class WreathBackendServer
{
    let listener: TransmissionTypes.Listener
    let handler: WreathBackend

    var running: Bool = true

    public init(listener: TransmissionTypes.Listener, handler: WreathBackend)
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
                    throw WreathBackendServerError.readFailed
                }

                let decoder = JSONDecoder()
                let request = try decoder.decode(WreathBackendRequest.self, from: requestData)
                switch request
                {
                    case .AddtransportserverconfigRequest(let value):
                        self.handler.addTransportServerConfig(config: value.config)
                        let response = WreathBackendResponse.AddtransportserverconfigResponse
                        let encoder = JSONEncoder()
                        let responseData = try encoder.encode(response)
                        guard connection.writeWithLengthPrefix(data: responseData, prefixSizeInBits: 64) else
                        {
                            throw WreathBackendServerError.writeFailed
                        }
                    case .RemovetransportserverconfigRequest(let value):
                        self.handler.removeTransportServerConfig(config: value.config)
                        let response = WreathBackendResponse.RemovetransportserverconfigResponse
                        let encoder = JSONEncoder()
                        let responseData = try encoder.encode(response)
                        guard connection.writeWithLengthPrefix(data: responseData, prefixSizeInBits: 64) else
                        {
                            throw WreathBackendServerError.writeFailed
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

public enum WreathBackendServerError: Error
{
    case connectionRefused(String, Int)
    case writeFailed
    case readFailed
    case badReturnType
}
