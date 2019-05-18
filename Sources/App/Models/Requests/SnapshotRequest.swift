//
//  SnapshotRequest.swift
//  App
//
//  Created by Alexander Peresypkin on 18/05/2019.
//

import Vapor

struct SnapshotRequest: Content {
    let deviceName: String
    let deviceVersion: String
    let reference: Data
    let failure: Data
    let diff: Data
}
