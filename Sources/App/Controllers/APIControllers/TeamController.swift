//
//  TeamController.swift
//  App
//
//  Created by Alexander Peresypkin on 16/05/2019.
//

import Vapor
import Fluent
import Authentication

final class TeamController: RouteCollection {
    
    // MARK: - RouteCollection
    
    func boot(router: Router) throws {
        
        let teamRouter = router.grouped("api", "v1", "team")
        teamRouter.get("info", use: getAllHandler)
        teamRouter.post(Team.self, use: createHandler)
        teamRouter.delete(Team.parameter, use: deleteHandler)
        teamRouter.put(Team.parameter, use: updateHandler)
    }
    
    // MARK: - Private
    
    private func getAllHandler(req: Request) throws -> Future<[Team]> {
        
        return Team.query(on: req).all()
    }
    
    private func createHandler(req: Request, team: Team) throws -> Future<Team> {
        
        try team.validate()
        return team.save(on: req)
    }
    
    private func deleteHandler(req: Request) throws -> Future<HTTPStatus> {
        
        return try req.parameters.next(Team.self).delete(on: req).transform(to: .noContent)
    }
    
    private func updateHandler(req: Request) throws -> Future<Team> {
        
        return try flatMap(req.parameters.next(Team.self), req.content.decode(TeamRequest.self)) { team, teamRequest in
            team.name = teamRequest.name
            try team.validate()
            return team.save(on: req)
        }
    }
}
