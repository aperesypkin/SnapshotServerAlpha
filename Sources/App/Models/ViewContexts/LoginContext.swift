//
//  LoginContext.swift
//  App
//
//  Created by Alexander Peresypkin on 17/03/2019.
//

import Vapor

struct LoginContext: Encodable {
    let title = "Login"
    let loginError: Bool
    
    init(loginError: Bool = false) {
        self.loginError = loginError
    }
}
