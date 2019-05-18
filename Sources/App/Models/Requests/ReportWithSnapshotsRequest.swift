//
//  ReportWithSnapshotsRequest.swift
//  App
//
//  Created by Alexander Peresypkin on 18/05/2019.
//

import Vapor

struct ReportWithSnapshotsRequest: Content {
    let report: Report
    let snapshots: [SnapshotRequest]
}
