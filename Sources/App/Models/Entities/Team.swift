//
//  Team.swift
//  App
//
//  Created by Alexander Peresypkin on 16/05/2019.
//

import Vapor
import FluentPostgreSQL

final class Team {
    
    // MARK: - Fields
    
    var id: Int?
    var name: String
    var createdAt: Date?
    var updatedAt: Date?
    
    // MARK: - Initialization
    
    init(name: String) {
        self.name = name
    }
}

// MARK: - PostgreSQLModel

extension Team: PostgreSQLModel {
    
    static var createdAtKey: TimestampKey? = \.createdAt
    static var updatedAtKey: TimestampKey? = \.updatedAt
    
    var reports: Children<Team, Report> {
        return children(\.teamID)
    }
}

// MARK: - Migration

extension Team: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.name)
        }
    }
}

// MARK: - Content

extension Team: Content {}

// MARK: - Parameter

extension Team: Parameter {}

// MARK: - Validatable

extension Team: Validatable {
    
    static func validations() throws -> Validations<Team> {
        var validations = Validations(self)
        try validations.add(\.name, .count(2...30))
        return validations
    }
}
