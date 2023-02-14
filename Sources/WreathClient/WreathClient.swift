//
//  WreathClient.swift
//
//
//  Created by Clockwork on Feb 14, 2023.
//

import Foundation

import Antiphony
import TransmissionTypes
import Wreath

public class WreathClient
{
    let connection: TransmissionTypes.Connection

    public init(connection: TransmissionTypes.Connection)
    {
        self.connection = connection
    }

    public func getTransportServerConfig(transportName: String, clientID: String) throws -> [TransportConfig]
    {
        let message = WreathRequest.getTransportServerConfig(Gettransportserverconfig(transportName: transportName, clientID: clientID))
        let encoder = JSONEncoder()
        let data = try encoder.encode(message)
        guard self.connection.writeWithLengthPrefix(data: data, prefixSizeInBits: 64) else
        {
            throw WreathClientError.writeFailed
        }

        guard let responseData = self.connection.readWithLengthPrefix(prefixSizeInBits: 64) else
        {
            throw WreathClientError.readFailed
        }

        let decoder = JSONDecoder()
        let response = try decoder.decode(WreathResponse.self, from: responseData)
        switch response
        {
            case .getTransportServerConfig(let value):
                return value
            default:
                throw WreathClientError.badReturnType
        }
    }

    public func getWreathServer(clientID: String) throws -> [ClientConfig]
    {
        let message = WreathRequest.getWreathServer(Getwreathserver(clientID: clientID))
        let encoder = JSONEncoder()
        let data = try encoder.encode(message)
        guard self.connection.writeWithLengthPrefix(data: data, prefixSizeInBits: 64) else
        {
            throw WreathClientError.writeFailed
        }

        guard let responseData = self.connection.readWithLengthPrefix(prefixSizeInBits: 64) else
        {
            throw WreathClientError.readFailed
        }

        let decoder = JSONDecoder()
        let response = try decoder.decode(WreathResponse.self, from: responseData)
        switch response
        {
            case .getWreathServer(let value):
                return value
            default:
                throw WreathClientError.badReturnType
        }
    }
}

public enum WreathClientError: Error
{
    case connectionRefused(String, Int)
    case writeFailed
    case readFailed
    case badReturnType
}
