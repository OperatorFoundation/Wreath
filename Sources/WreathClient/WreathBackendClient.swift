//
//  WreathBackendClient.swift
//
//
//  Created by Clockwork on Mar 7, 2023.
//

import Foundation

import TransmissionTypes
import Wreath

public class WreathBackendClient
{
    let connection: TransmissionTypes.Connection

    public init(connection: TransmissionTypes.Connection)
    {
        self.connection = connection
    }

    public func addTransportServerConfig(config: TransportConfig) throws
    {
        let message = WreathBackendRequest.AddtransportserverconfigRequest(Addtransportserverconfig(config: config))
        let encoder = JSONEncoder()
        let data = try encoder.encode(message)
        guard self.connection.writeWithLengthPrefix(data: data, prefixSizeInBits: 64) else
        {
            throw WreathBackendClientError.writeFailed
        }

        guard let responseData = self.connection.readWithLengthPrefix(prefixSizeInBits: 64) else
        {
            throw WreathBackendClientError.readFailed
        }

        let decoder = JSONDecoder()
        let response = try decoder.decode(WreathBackendResponse.self, from: responseData)
        switch response
        {
            case .AddtransportserverconfigResponse:
                return
            default:
                throw WreathBackendClientError.badReturnType
        }
    }

    public func removeTransportServerConfig(config: TransportConfig) throws
    {
        let message = WreathBackendRequest.RemovetransportserverconfigRequest(Removetransportserverconfig(config: config))
        let encoder = JSONEncoder()
        let data = try encoder.encode(message)
        guard self.connection.writeWithLengthPrefix(data: data, prefixSizeInBits: 64) else
        {
            throw WreathBackendClientError.writeFailed
        }

        guard let responseData = self.connection.readWithLengthPrefix(prefixSizeInBits: 64) else
        {
            throw WreathBackendClientError.readFailed
        }

        let decoder = JSONDecoder()
        let response = try decoder.decode(WreathBackendResponse.self, from: responseData)
        switch response
        {
            case .RemovetransportserverconfigResponse:
                return
            default:
                throw WreathBackendClientError.badReturnType
        }
    }
}

public enum WreathBackendClientError: Error
{
    case connectionRefused(String, Int)
    case writeFailed
    case readFailed
    case badReturnType
}
