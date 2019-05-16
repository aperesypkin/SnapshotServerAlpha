//
//  Report.swift
//  App
//
//  Created by Alexander Peresypkin on 17/05/2019.
//

import Vapor
import FluentPostgreSQL

final class Report {
    
    // MARK: - Fields
    
    var id: Int?
    var screenName: String
    var createdAt: Date?
    var updatedAt: Date?
    var teamID: Team.ID
    
    // MARK: - Initialization
    
    init(screenName: String, teamID: Team.ID) {
        self.screenName = screenName
        self.teamID = teamID
    }
}

// MARK: - PostgreSQLModel

extension Report: PostgreSQLModel {
    
    static var createdAtKey: TimestampKey? = \.createdAt
    static var updatedAtKey: TimestampKey? = \.updatedAt
    
    var team: Parent<Report, Team> {
        return parent(\.teamID)
    }
    
    var snapshots: Children<Report, Snapshot> {
        return children(\.reportID)
    }
}

// MARK: - Migration

extension Report: Migration {
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.teamID, to: \Team.id, onDelete: .cascade)
        }
    }
}

// MARK: - Content

extension Report: Content {}

// MARK: - Parameter

extension Report: Parameter {}

// MARK: - Validatable

extension Report: Validatable {
    
    static func validations() throws -> Validations<Report> {
        var validations = Validations(self)
        try validations.add(\.screenName, .count(3...50))
        return validations
    }
}
