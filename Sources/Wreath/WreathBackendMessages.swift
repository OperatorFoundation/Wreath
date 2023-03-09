//
//  WreathBackendMessages.swift
//
//
//  Created by Clockwork on Mar 8, 2023.
//

public enum WreathBackendRequest: Codable
{
    case AddtransportserverconfigRequest(Addtransportserverconfig)
    case RemovetransportserverconfigRequest(Removetransportserverconfig)
}

public struct Addtransportserverconfig: Codable
{
    public let config: TransportConfig

    public init(config: TransportConfig)
    {
        self.config = config
    }
}

public struct Removetransportserverconfig: Codable
{
    public let config: TransportConfig

    public init(config: TransportConfig)
    {
        self.config = config
    }
}

public enum WreathBackendResponse: Codable
{
    case AddtransportserverconfigResponse
    case RemovetransportserverconfigResponse
}