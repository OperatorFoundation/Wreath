//
//  WreathFrontendMessages.swift
//
//
//  Created by Clockwork on Mar 7, 2023.
//

import Arcadia

public enum WreathFrontendRequest: Codable
{
    case GettransportserverconfigsRequest(Gettransportserverconfigs)
    case GetwreathserversRequest(Getwreathservers)
}

public struct Gettransportserverconfigs: Codable
{
    public let transportName: String
    public let clientID: String

    public init(transportName: String, clientID: String)
    {
        self.transportName = transportName
        self.clientID = clientID
    }
}

public struct Getwreathservers: Codable
{
    public let clientID: String

    public init(clientID: String)
    {
        self.clientID = clientID
    }
}

public enum WreathFrontendResponse: Codable
{
    case GettransportserverconfigsResponse([TransportConfig])
    case GetwreathserversResponse([WreathServerInfo])
}
