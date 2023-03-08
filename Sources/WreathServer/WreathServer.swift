//
//  WreathServer.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/8/23.
//

import Foundation

import Antiphony
import Spacetime

public class WreathServer
{
    let state: WreathState
    let frontend: WreathFrontendServer
    let backend: WreathBackendServer
    let antiphonyBackend: Antiphony

    public init(serverFrontendConfigURL: URL, serverBackendConfigURL: URL, loggerLabel: String) throws
    {
        self.state = try WreathState()

        let antiphonyFrontend = try Antiphony(serverConfigURL: serverFrontendConfigURL, loggerLabel: loggerLabel, capabilities: Capabilities(.display, .networkListen))

        guard let antiphonyFrontendListener = antiphonyFrontend.listener else
        {
            throw WreathServerError.failedToLaunchFrontend
        }

        let wreathFrontendLogic = try WreathFrontend(state: state)
        self.frontend = WreathFrontendServer(listener: antiphonyFrontendListener, handler: wreathFrontendLogic)

        self.antiphonyBackend = try Antiphony(serverConfigURL: serverBackendConfigURL, loggerLabel: loggerLabel, capabilities: Capabilities(.display, .networkListen))

        guard let antiphonyBackendListener = self.antiphonyBackend.listener else
        {
            throw WreathServerError.failedToLaunchBackend
        }

        let wreathBackendLogic = try WreathBackend(state: state)
        self.backend = WreathBackendServer(listener: antiphonyBackendListener, handler: wreathBackendLogic)
    }

    public func wait()
    {
        self.antiphonyBackend.wait()
    }
}

public enum WreathServerError: Error
{
    case failedToLaunchFrontend
    case failedToLaunchBackend
}
