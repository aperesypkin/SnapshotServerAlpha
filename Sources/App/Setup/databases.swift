//
//  databases.swift
//  App
//
//  Created by Alexander Peresypkin on 13/03/2019.
//

import Vapor
import FluentPostgreSQL

public func databases(config: inout DatabasesConfig) throws {
    
    let pgConfig = PostgreSQLDatabaseConfig(hostname: "localhost",
                                            port: 5432,
                                            username: "postgres",
                                            database: "snapshot_alpha_server",
                                            password: "123456")
    
    let database = PostgreSQLDatabase(config: pgConfig)
    
    config.add(database: database, as: .psql)
}
