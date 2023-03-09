//
//  WreathFrontendClient.swift
//
//
//  Created by Clockwork on Mar 8, 2023.
//

import Foundation

import Arcadia
import TransmissionTypes
import Wreath

public class WreathFrontendClient
{
    let connection: TransmissionTypes.Connection

    public init(connection: TransmissionTypes.Connection)
    {
        self.connection = connection
    }

    public func getTransportServerConfigs(transportName: String, clientID: String) throws -> [TransportConfig]
    {
        let message = WreathFrontendRequest.GettransportserverconfigsRequest(Gettransportserverconfigs(transportName: transportName, clientID: clientID))
        let encoder = JSONEncoder()
        let data = try encoder.encode(message)
        guard self.connection.writeWithLengthPrefix(data: data, prefixSizeInBits: 64) else
        {
            throw WreathFrontendClientError.writeFailed
        }

        guard let responseData = self.connection.readWithLengthPrefix(prefixSizeInBits: 64) else
        {
            throw WreathFrontendClientError.readFailed
        }

        let decoder = JSONDecoder()
        let response = try decoder.decode(WreathFrontendResponse.self, from: responseData)
        switch response
        {
            case .GettransportserverconfigsResponse(let value):
                return value
            default:
                throw WreathFrontendClientError.badReturnType
        }
    }

    public func getWreathServers(clientID: String) throws -> [WreathServerInfo]
    {
        let message = WreathFrontendRequest.GetwreathserversRequest(Getwreathservers(clientID: clientID))
        let encoder = JSONEncoder()
        let data = try encoder.encode(message)
        guard self.connection.writeWithLengthPrefix(data: data, prefixSizeInBits: 64) else
        {
            throw WreathFrontendClientError.writeFailed
        }

        guard let responseData = self.connection.readWithLengthPrefix(prefixSizeInBits: 64) else
        {
            throw WreathFrontendClientError.readFailed
        }

        let decoder = JSONDecoder()
        let response = try decoder.decode(WreathFrontendResponse.self, from: responseData)
        switch response
        {
            case .GetwreathserversResponse(let value):
                return value
            default:
                throw WreathFrontendClientError.badReturnType
        }
    }
}

public enum WreathFrontendClientError: Error
{
    case connectionRefused(String, Int)
    case writeFailed
    case readFailed
    case badReturnType
}
