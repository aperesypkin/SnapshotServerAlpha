//
//  UserController.swift
//  App
//
//  Created by Alexander Peresypkin on 21/03/2019.
//

import Vapor
import Fluent
import Authentication

final class UserController: RouteCollection {
    
    // MARK: - RouteCollection
    
    func boot(router: Router) throws {
        
        let userRouter = router.grouped("api", "v1", "user")
        userRouter.get("info", use: getAllHandler)
        
        let basicAuthRouter = userRouter.grouped(User.basicAuthMiddleware(using: BCryptDigest()))
        basicAuthRouter.post("login", use: loginHandler)
    }
    
    // MARK: - Private
    
    private func getAllHandler(req: Request) throws -> Future<[User]> {
        
        return User.query(on: req).all()
    }
    
    func loginHandler(req: Request) throws -> Future<Token> {
        
        let user = try req.requireAuthenticated(User.self)
        let token = try Token.generate(for: user)
        return token.save(on: req)
    }
}
