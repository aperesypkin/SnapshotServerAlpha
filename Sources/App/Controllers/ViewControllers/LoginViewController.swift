//
//  LoginViewController.swift
//  App
//
//  Created by Alexander Peresypkin on 17/03/2019.
//

import Vapor
import Fluent
import Leaf
import Authentication

final class LoginViewController: RouteCollection {
    
    // MARK: - RouteCollection
    
    func boot(router: Router) throws {
        
        let loginRouter = router.grouped("login")
        let authSessionsMiddleware = User.authSessionsMiddleware()
        let authRouter = loginRouter.grouped(authSessionsMiddleware)
        authRouter.get(use: loginHandler)
        authRouter.post(User.self, use: loginPostHandler)
    }
    
    // MARK: - Private
    
    private func loginHandler(req: Request) throws -> Future<View> {
        
        let context: LoginContext
        if req.query[Bool.self, at: "error"] != nil {
            context = LoginContext(loginError: true)
        } else {
            context = LoginContext()
        }
        return try req.view().render("login", context)
    }
    
    private func loginPostHandler(req: Request, user: User) throws -> Future<Response> {
        
        return User.authenticate(username: user.username, password: user.password, using: BCryptDigest(), on: req).map(to: Response.self) { user in
            guard let user = user else { return req.redirect(to: "login?error") }
            try req.authenticateSession(user)
            return req.redirect(to: "/")
        }
    }
}
