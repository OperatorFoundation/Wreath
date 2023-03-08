//
//  WreathState.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/7/23.
//

import Foundation

import Arcadia
import ShadowSwift
import Wreath

public class WreathState
{
    public var shadowConfigs = Set<TransportConfig>()

    let lock = DispatchSemaphore(value: 1)
    let arcadia: Arcadia = Arcadia()

    var shadowInfos: [WreathServerInfo] = []

    public init() throws
    {
    }

    public func getConfigs(transportName: String, clientID: ArcadiaID) -> [TransportConfig]
    {
        defer
        {
            self.lock.signal()
        }
        self.lock.wait()

        switch transportName
        {
            case "shadow":
                let infos = self.arcadia.findServers(for: clientID)
                return infos.compactMap
                {
                    info in

                    return infoToConfig(info)
                }

            default:
                return []
        }
    }

    public func add(config: TransportConfig) throws
    {
        defer
        {
            self.lock.signal()
        }
        self.lock.wait()

        switch config
        {
            case .shadow(_):
                self.shadowConfigs.insert(config)

                let info = configToInfo(config)
                self.shadowInfos.append(info)
                try self.arcadia.addServer(wreathServer: info)
        }
    }

    public func remove(config: TransportConfig) throws
    {
        defer
        {
            self.lock.signal()
        }
        self.lock.wait()

        switch config
        {
            case .shadow(_):
                self.shadowConfigs.remove(config)

                let info = configToInfo(config)
                self.shadowInfos = self.shadowInfos.filter
                {
                    shadowInfo in

                    shadowInfo.serverAddress != info.serverAddress
                }
                try self.arcadia.removeServer(wreathServer: info)
        }
    }

    func configToInfo(_ config: TransportConfig) -> WreathServerInfo
    {
        switch config
        {
            case .shadow(let shadowConfig):
                return WreathServerInfo(publicKey: shadowConfig.serverPublicKey, serverAddress: shadowConfig.serverAddress)
        }
    }

    func infoToConfig(_ info: WreathServerInfo) -> TransportConfig?
    {
        return self.shadowConfigs.first
        {
            config in

            switch config
            {
                case .shadow(let shadowConfig):
                    return shadowConfig.serverAddress == info.serverAddress
            }
        }
    }
}
