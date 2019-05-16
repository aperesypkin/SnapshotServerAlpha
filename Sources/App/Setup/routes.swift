import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // MARK: APIControllers
    
    try router.register(collection: UserController())
    try router.register(collection: TeamController())
    
    // MARK: ViewControllers
    
    try router.register(collection: LoginViewController())
}
