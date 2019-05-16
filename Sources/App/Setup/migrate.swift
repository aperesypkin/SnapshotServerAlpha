//
//  migrate.swift
//  App
//
//  Created by Alexander Peresypkin on 13/03/2019.
//

import Vapor
import FluentPostgreSQL

public func migrate(migrations: inout MigrationConfig) throws {
    
    // MARK: - Enums
    
    // MARK: - Entities
    
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Token.self, database: .psql)
    migrations.add(model: Team.self, database: .psql)
    migrations.add(model: Report.self, database: .psql)
    migrations.add(model: Snapshot.self, database: .psql)
    
    // MARK: - Pivots
    
    // MARK: - Database data
    
    migrations.add(migration: AdminUser.self, database: .psql)
    
    // MARK: - Migrations
}
