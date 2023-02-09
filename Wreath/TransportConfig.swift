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
