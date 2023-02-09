//
//  WreathClient.swift
//
//
//  Created by Clockwork on Feb 8, 2023.
//

import Foundation

import TransmissionTypes

public class WreathClient
{
    let connection: TransmissionTypes.Connection

    public init(connection: TransmissionTypes.Connection)
    {
        self.connection = connection
    }

    public func getTransportServerConfig(transportName: String, clientID: String) throws -> TransportConfig?
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