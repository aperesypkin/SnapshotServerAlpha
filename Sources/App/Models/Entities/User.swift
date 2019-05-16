//
//  User.swift
//  App
//
//  Created by Alexander Peresypkin on 16/03/2019.
//

import Vapor
import FluentPostgreSQL
import Authentication

final class User {
    
    // MARK: - Fields
    
    var id: Int?
    var username: String
    var password: String
    var createdAt: Date?
    var updatedAt: Date?
    
    // MARK: - Initialization
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

// MARK: - PostgreSQLModel

extension User: PostgreSQLModel {
    
    static var createdAtKey: TimestampKey? = \.createdAt
    static var updatedAtKey: TimestampKey? = \.updatedAt
    
    var tokens: Children<User, Token> {
        return children(\.userID)
    }
}

// MARK: - Migration

extension User: Migration {}

// MARK: - Content

extension User: Content {}

// MARK: - Parameter

extension User: Parameter {}

// MARK: - TokenAuthenticatable

extension User: TokenAuthenticatable {
    
    typealias TokenType = Token
}

// MARK: - PasswordAuthenticatable

extension User: PasswordAuthenticatable {
    
    static let usernameKey: UsernameKey = \.username
    static let passwordKey: PasswordKey = \.password
}

// MARK: - SessionAuthenticatable

extension User: SessionAuthenticatable {}

// MARK: - Database migrations

struct AdminUser: PostgreSQLMigration {
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        let password = try? BCrypt.hash("123456")
        guard let hashedPassword = password else { fatalError("Failed to create admin user") }
        let user = User(username: "admin", password: hashedPassword)
        return user.save(on: conn).transform(to: ())
    }
    
    static func revert(on conn: PostgreSQLConnection) -> Future<Void> {
        return .done(on: conn)
    }
}
