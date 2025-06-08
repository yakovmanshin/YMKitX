//
//  ErrorReportingServiceProtocol.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 5/24/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

protocol ErrorReportingServiceProtocol: Sendable {
    func start() async throws
    func reportError(_ error: any Error) async throws
}
