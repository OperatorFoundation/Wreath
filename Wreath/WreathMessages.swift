//
//  WreathMessages.swift
//
//
//  Created by Clockwork on Feb 8, 2023.
//

public enum WreathRequest: Codable
{
    case getTransportServerConfig(Gettransportserverconfig)
}

public struct Gettransportserverconfig: Codable
{
    public let transportName: String
    public let clientID: String

    public init(transportName: String, clientID: String)
    {
        self.transportName = transportName
        self.clientID = clientID
    }
}

public enum WreathResponse: Codable
{
    case getTransportServerConfig(TransportConfig?)
}