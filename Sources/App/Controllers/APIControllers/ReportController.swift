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
        
        reportRouter.post("snapshots", use: createWithSnapshotsHandler)
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
    
    private func createWithSnapshotsHandler(req: Request) throws -> Future<HTTPStatus> {
        
        // /Users/aperesypkin/Development/SnapshotServerAlpha/
        guard let workDir = DirectoryConfig.detect().workDir.convertToURL() else { throw Abort(.internalServerError) }
        let snapshotsDir = workDir.appendingPathComponent("Public/snapshots")
        
        return try req.content.decode(ReportWithSnapshotsRequest.self).flatMap { request in
            try request.report.validate()
            
            return request.report.save(on: req).flatMap { report in
                guard let reportID = report.id else { throw Abort(.badRequest) }
                
                return report.team.get(on: req).flatMap { team in
                    let teamDir = snapshotsDir.appendingPathComponent(team.name, isDirectory: true)
                    
                    do {
                        try FileManager.default.createDirectory(at: URL(fileURLWithPath: teamDir.absoluteString),
                                                                withIntermediateDirectories: true)
                    } catch {
                        print("error: \(error)")
                        throw Abort(.internalServerError)
                    }
                    
                    return try request.snapshots.map { snapshotRequest in
                        let referenceName = "reference_\(team.name)_\(UUID().uuidString)"
                        let failureName = "failure_\(team.name)_\(UUID().uuidString)"
                        let diffName = "diff_\(team.name)_\(UUID().uuidString)"
                        
                        let referenceSavePath = teamDir
                            .appendingPathComponent(referenceName, isDirectory: false)
                            .appendingPathExtension(.imageExtension)
                            .absoluteString
                        let failureSavePath = teamDir
                            .appendingPathComponent(failureName, isDirectory: false)
                            .appendingPathExtension(.imageExtension)
                            .absoluteString
                        let diffSavePath = teamDir
                            .appendingPathComponent(diffName, isDirectory: false)
                            .appendingPathExtension(.imageExtension)
                            .absoluteString
                        
                        do {
                            try snapshotRequest.reference.write(to: URL(fileURLWithPath: referenceSavePath))
                            try snapshotRequest.failure.write(to: URL(fileURLWithPath: failureSavePath))
                            try snapshotRequest.diff.write(to: URL(fileURLWithPath: diffSavePath))
                        } catch {
                            print("error: \(error)")
                            throw Abort(.internalServerError)
                        }
                        
                        let snapshot = Snapshot(deviceName: snapshotRequest.deviceName,
                                                deviceVersion: snapshotRequest.deviceVersion,
                                                reference: referenceName,
                                                failure: failureName,
                                                diff: diffName,
                                                reportID: reportID)
                        try snapshot.validate()
                        return snapshot.save(on: req).transform(to: ())
                        }.flatten(on: req).transform(to: .ok)
                }
            }
        }
    }
}
