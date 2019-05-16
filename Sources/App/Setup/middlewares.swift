//
//  middlewares.swift
//  App
//
//  Created by Alexander Peresypkin on 13/03/2019.
//

import Vapor

public func middlewares(config: inout MiddlewareConfig) throws {
    
    config.use(FileMiddleware.self) // Serves files from `Public/` directory
    config.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    config.use(SessionsMiddleware.self)
}

