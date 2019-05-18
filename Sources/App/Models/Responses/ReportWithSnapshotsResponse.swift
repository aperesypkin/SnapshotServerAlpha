//
//  ReportWithSnapshotsResponse.swift
//  App
//
//  Created by Alexander Peresypkin on 18/05/2019.
//

import Vapor

struct ReportWithSnapshotsResponse: Content {
    let id: Int
    let screenName: String
    let createdAt: Date
    let updatedAt: Date
    let teamID: Team.ID
    let snapshots: [Snapshot]
}
