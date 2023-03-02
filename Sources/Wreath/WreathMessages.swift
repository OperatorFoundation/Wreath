//
//  WreathMessages.swift
//
//
//  Created by Clockwork on Mar 1, 2023.
//

import Arcadia
import Antiphony

public enum WreathRequest: Codable
{
    case GettransportserverconfigsRequest(Gettransportserverconfigs)
    case GetwreathserversRequest(Getwreathservers)
}

public struct Gettransportserverconfigs: Codable
{
    public let transportName: String
    public let clientID: ArcadiaID

    public init(transportName: String, clientID: ArcadiaID)
    {
        self.transportName = transportName
        self.clientID = clientID
    }
}

public struct Getwreathservers: Codable
{
    public let clientID: ArcadiaID

    public init(clientID: ArcadiaID)
    {
        self.clientID = clientID
    }
}

public enum WreathResponse: Codable
{
    case GettransportserverconfigsResponse([TransportConfig])
    case GetwreathserversResponse([ClientConfig])
}
