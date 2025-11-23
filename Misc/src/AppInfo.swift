//
//  AppInfo.swift
//  YMMisc
//
//  Created by Yakov Manshin on 3/10/21.
//  Copyright © 2021 Yakov Manshin. See the LICENSE file for license info.
//

import Foundation

/// The object that provides information about the host app.
final public class AppInfo: Sendable {
    
    public static let `default` = AppInfo(bundle: .main)
    
    private let bundle: Bundle
    
    public init(bundle: Bundle) {
        self.bundle = bundle
    }
    
}

public extension AppInfo {
    
    /// The display name (product name) of the host app.
    var name: String? {
        bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
    
    /// The bundle identifier of the host app.
    var bundleID: String? {
        bundle.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String
    }
    
    /// The bundle name of the host app.
    var bundleName: String? {
        bundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
    }
    
    /// The executable name of the host app.
    var executableName: String? {
        bundle.object(forInfoDictionaryKey: kCFBundleExecutableKey as String) as? String
    }
    
    /// The version number of the host app.
    var version: String? {
        bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    /// The build number of the host app.
    var build: String? {
        bundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
    
}
