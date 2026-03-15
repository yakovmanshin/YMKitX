//
//  LogLevel.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 3/14/26.
//  Copyright © 2026 Yakov Manshin. See the LICENSE file for license info.
//

/// The indicator that controls how and when the system writes a message to the backing logging system.
///
/// - SeeAlso: [`OSLogType`](https://developer.apple.com/documentation/os/oslogtype)
public enum LogLevel: Sendable {
    case debug
    case info
    case `default`
    case error
    case fault
}
