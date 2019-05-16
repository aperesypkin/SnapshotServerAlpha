//
//  SnapshotController.swift
//  App
//
//  Created by Alexander Peresypkin on 17/05/2019.
//

import Vapor
import Fluent
import Authentication

final class SnapshotController: RouteCollection {
    
    // MARK: - RouteCollection
    
    func boot(router: Router) throws {
        
        let snapshotRouter = router.grouped("api", "v1", "snapshot")
        snapshotRouter.get("info", use: getAllHandler)
//        snapshotRouter.post(Snapshot.self, use: createHandler)
        snapshotRouter.delete(Report.parameter, use: deleteHandler)
//        snapshotRouter.put(Snapshot.parameter, use: updateHandler)
    }
    
    // MARK: - Private
    
    private func getAllHandler(req: Request) throws -> Future<[Snapshot]> {
        
        return Snapshot.query(on: req).all()
    }
    
//    private func createHandler(req: Request, snapshot: Snapshot) throws -> Future<Snapshot> {
//
//        try snapshot.validate()
//        return snapshot.save(on: req)
//    }
    
    private func deleteHandler(req: Request) throws -> Future<HTTPStatus> {
        
        return try req.parameters.next(Snapshot.self).delete(on: req).transform(to: .noContent)
    }
    
//    private func updateHandler(req: Request) throws -> Future<Report> {
//
//        return try flatMap(req.parameters.next(Report.self), req.content.decode(ReportRequest.self)) { report, reportRequest in
//            report.screenName = reportRequest.screenName
//            try report.validate()
//            return report.save(on: req)
//        }
//    }
}
