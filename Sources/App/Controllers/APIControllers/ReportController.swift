//
//  ReportController.swift
//  App
//
//  Created by Alexander Peresypkin on 17/05/2019.
//

import Vapor
import Fluent
import Authentication

final class ReportController: RouteCollection {
    
    // MARK: - RouteCollection
    
    func boot(router: Router) throws {
        
        let reportRouter = router.grouped("api", "v1", "report")
        reportRouter.get("info", use: getAllHandler)
        reportRouter.post(Report.self, use: createHandler)
        reportRouter.delete(Report.parameter, use: deleteHandler)
        reportRouter.put(Report.parameter, use: updateHandler)
    }
    
    // MARK: - Private
    
    private func getAllHandler(req: Request) throws -> Future<[Report]> {
        
        return Report.query(on: req).all()
    }
    
    private func createHandler(req: Request, report: Report) throws -> Future<Report> {
        
        try report.validate()
        return report.save(on: req)
    }
    
    private func deleteHandler(req: Request) throws -> Future<HTTPStatus> {
        
        return try req.parameters.next(Report.self).delete(on: req).transform(to: .noContent)
    }
    
    private func updateHandler(req: Request) throws -> Future<Report> {
        
        return try flatMap(req.parameters.next(Report.self), req.content.decode(ReportRequest.self)) { report, reportRequest in
            report.screenName = reportRequest.screenName
            try report.validate()
            return report.save(on: req)
        }
    }
}

