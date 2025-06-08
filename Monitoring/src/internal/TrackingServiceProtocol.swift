//
//  TrackingServiceProtocol.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 5/18/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

protocol TrackingServiceProtocol: Sendable {
    func start() async throws
    func track(_ event: TrackingEvent) async throws
}
