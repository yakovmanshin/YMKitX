//
//  AppIdentity.swift
//  YMAppReceiptValidation
//
//  Created by Yakov Manshin on 6/13/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

import YMUtilities

public struct AppIdentity: Sendable {
    
    let bundleIdentifier: String
    let version: SoftwareVersion
    
    public init(bundleIdentifier: String, version: SoftwareVersion) {
        self.bundleIdentifier = bundleIdentifier
        self.version = version
    }
    
}
