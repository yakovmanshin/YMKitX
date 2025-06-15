//
//  AppIdentity.swift
//  YMAppReceiptValidation
//
//  Created by Yakov Manshin on 6/13/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

/// The object that fixes the identity of the app in place.
public struct AppIdentity: Sendable {
    
    let bundleIdentifier: String
    let version: SoftwareVersion
    
    /// Initializes a new `AppIdentity`.
    ///
    /// + This object is supposed to be initialized using string literals. Don’t use `Bundle` as it retrieves values from `Info.plist` at runtime.
    ///
    /// - Parameters:
    ///   - bundleIdentifier: *Required.* The main bundle’s identifier.
    ///   - version: *Required.* The main bundle’s current version.
    public init(bundleIdentifier: String, version: SoftwareVersion) {
        self.bundleIdentifier = bundleIdentifier
        self.version = version
    }
    
}
