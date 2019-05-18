import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // MARK: APIControllers
    
    try router.register(collection: UserController())
    try router.register(collection: TeamController())
    try router.register(collection: ReportController())
    try router.register(collection: SnapshotController())
    
    // MARK: ViewControllers
    
    try router.register(collection: LoginViewController())
}
