//
//  Token.swift
//  App
//
//  Created by Alexander Peresypkin on 16/03/2019.
//

import Vapor
import FluentPostgreSQL
import Authentication

final class Token {
    
    // MARK: - Fields
    
    var id: UUID?
    var token: String
    var userID: User.ID
    
    // MARK: - Initialization
    
    init(token: String, userID: User.ID) {
        self.token = token
        self.userID = userID
    }
}

// MARK: - PostgreSQLUUIDModel

extension Token: PostgreSQLUUIDModel {
    
    var user: Parent<Token, User> {
        return parent(\.userID)
    }
}

// MARK: - Migration

extension Token: Migration {}

// MARK: - Content

extension Token: Content {}

// MARK: - Token

extension Token: Authentication.Token {
    
    typealias UserType = User
    
    static let tokenKey: TokenKey = \.token
    static let userIDKey: UserIDKey = \.userID
}

// MARK: - Supporting functions

extension Token {
    
    static func generate(for user: User) throws -> Token {
        let random = try CryptoRandom().generateData(count: 16)
        return try Token(token: random.base64EncodedString(), userID: user.requireID())
    }
}
