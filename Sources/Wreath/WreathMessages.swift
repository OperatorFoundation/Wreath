//
//  WreathMessages.swift
//
//
//  Created by Clockwork on Feb 14, 2023.
//

import Antiphony

public enum WreathRequest: Codable
{
    case getTransportServerConfig(Gettransportserverconfig)
    case getWreathServer(Getwreathserver)
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

public struct Getwreathserver: Codable
{
    public let clientID: String

    public init(clientID: String)
    {
        self.clientID = clientID
    }
}

public enum WreathResponse: Codable
{
    case getTransportServerConfig([TransportConfig])
    case getWreathServer([ClientConfig])
}
