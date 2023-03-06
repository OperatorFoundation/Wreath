//
//  WreathMessages.swift
//
//
//  Created by Clockwork on Mar 6, 2023.
//

public enum WreathRequest: Codable
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

public enum WreathResponse: Codable
{
    case GettransportserverconfigsResponse([TransportConfig])
    case GetwreathserversResponse([WreathServerInfo])
}