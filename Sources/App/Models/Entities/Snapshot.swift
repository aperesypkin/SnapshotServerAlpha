//
//  Snapshot.swift
//  App
//
//  Created by Alexander Peresypkin on 17/05/2019.
//

import Vapor
import FluentPostgreSQL

final class Snapshot {
    
    // MARK: - Fields
    
    var id: Int?
    var deviceName: String
    var deviceVersion: String
    var reference: String
    var failure: String
    var diff: String
    var createdAt: Date?
    var updatedAt: Date?
    var reportID: Report.ID
    
    // MARK: - Initialization
    
    init(deviceName: String,
         deviceVersion: String,
         reference: String,
         failure: String,
         diff: String,
         reportID: Report.ID) {
        self.deviceName = deviceName
        self.deviceVersion = deviceVersion
        self.reference = reference
        self.failure = failure
        self.diff = diff
        self.reportID = reportID
    }
}

// MARK: - PostgreSQLModel

extension Snapshot: PostgreSQLModel {
    
    static var createdAtKey: TimestampKey? = \.createdAt
    static var updatedAtKey: TimestampKey? = \.updatedAt
    
    var report: Parent<Snapshot, Report> {
        return parent(\.reportID)
    }
}

// MARK: - Migration

extension Snapshot: Migration {
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: conn) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.reportID, to: \Report.id, onDelete: .cascade)
        }
    }
}

// MARK: - Content

extension Snapshot: Content {}

// MARK: - Parameter

extension Snapshot: Parameter {}

// MARK: - Validatable

extension Snapshot: Validatable {
    
    static func validations() throws -> Validations<Snapshot> {
        var validations = Validations(self)
        try validations.add(\.deviceName, .count(5...20))
        try validations.add(\.deviceVersion, .count(1...6))
        try validations.add(\.reference, .count(2...100))
        try validations.add(\.failure, .count(2...100))
        try validations.add(\.diff, .count(2...100))
        return validations
    }
}

