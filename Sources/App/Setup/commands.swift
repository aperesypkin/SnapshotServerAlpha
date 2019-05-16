//
//  commands.swift
//  App
//
//  Created by Alexander Peresypkin on 06/04/2019.
//

import Vapor

public func commands(config: inout CommandConfig) {
    
    config.useFluentCommands()
}
