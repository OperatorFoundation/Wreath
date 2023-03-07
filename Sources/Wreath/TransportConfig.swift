//
//  TransportConfig.swift
//  Wreath
//
//  Created by Joseph Bragel on 2/8/23.
//

import Foundation

import ShadowSwift
//import Starbridge

public enum TransportConfig: Codable, CustomStringConvertible
{
    case shadow(ShadowConfig.ShadowClientConfig)
//    case starbridge(StarbridgeClientConfig)
    
    public var description: String
    {
        switch self
        {
            case .shadow(_):
                return "shadow"
//            case .starbridge(_):
//                return "starbridge"
        }
    }
}

extension TransportConfig: Equatable
{
    public static func == (lhs: TransportConfig, rhs: TransportConfig) -> Bool
    {
        switch lhs
        {
            case .shadow(let lconfig):
                switch rhs
                {
                    case .shadow(let rconfig):
                        return lconfig == rconfig
                }
        }
    }
}

extension ShadowConfig.ShadowClientConfig: Equatable
{
    public static func == (lhs: ShadowConfig.ShadowClientConfig, rhs: ShadowConfig.ShadowClientConfig) -> Bool
    {
        return lhs.serverAddress == rhs.serverAddress
    }
}

extension TransportConfig: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        switch self
        {
            case .shadow(let shadow):
                hasher.combine(shadow.serverAddress)
        }
    }
}
