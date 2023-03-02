//
//  WreathClient.swift
//
//
//  Created by Clockwork on Mar 1, 2023.
//

import Foundation

import Arcadia
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

    public func getTransportServerConfigs(transportName: String, clientID: ArcadiaID) throws -> [TransportConfig]
    {
        let message = WreathRequest.GettransportserverconfigsRequest(Gettransportserverconfigs(transportName: transportName, clientID: clientID))
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
            case .GettransportserverconfigsResponse(let value):
                return value
            default:
                throw WreathClientError.badReturnType
        }
    }

    public func getWreathServers(clientID: ArcadiaID) throws -> [ClientConfig]
    {
        let message = WreathRequest.GetwreathserversRequest(Getwreathservers(clientID: clientID))
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
            case .GetwreathserversResponse(let value):
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
