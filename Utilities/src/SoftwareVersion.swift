//
//  SoftwareVersion.swift
//  YMUtilities
//
//  Created by Yakov Manshin on 2/15/22.
//  Copyright © 2022 Yakov Manshin. See the LICENSE file for license info.
//

import Foundation

// MARK: - SoftwareVersion

public struct SoftwareVersion: Sendable {
    
    let major: Int
    let minor: Int
    let patch: Int
    
    init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
}

// MARK: - Version String

extension SoftwareVersion {
    
    var string: String {
        "\(major).\(minor).\(patch)"
    }
    
    public init?(_ string: String) {
        try? self.init(string: string)
    }
    
    private init(string: String) throws {
        try Self.validateVersionString(string)
        
        let versionComponents = Self.versionComponents(from: string)
        
        let major: Int
        let minor: Int
        let patch: Int
        
        switch versionComponents.count {
        case 3:
            major = versionComponents[0]
            minor = versionComponents[1]
            patch = versionComponents[2]
        case 2:
            major = versionComponents[0]
            minor = versionComponents[1]
            patch = 0
        case 1:
            major = versionComponents[0]
            minor = 0
            patch = 0
        default:
            throw InitializationError.unsupportedNumberOfComponents(versionComponents.count)
        }
        
        self.init(major: major, minor: minor, patch: patch)
    }
    
    static func validateVersionString(_ string: String) throws {
        let versionStringRange = NSRange(location: 0, length: string.count)
        let regExPattern = #"^\d+(.\d+|)*$"#
        let versionStringRegEx: NSRegularExpression
        
        do {
            versionStringRegEx = try NSRegularExpression(pattern: regExPattern)
        } catch {
            throw InitializationError.failedToInitializeRegEx(error)
        }
        
        guard versionStringRegEx.numberOfMatches(in: string, options: [], range: versionStringRange) > 0 else {
            throw InitializationError.versionStringDoesNotMatchRegEx(regExPattern)
        }
    }
    
    private static func versionComponents(from string: String) -> [Int] {
        string
            .split(separator: ".")
            .map { Int($0) ?? 0 }
    }
    
}

// MARK: - Operating System Version

extension SoftwareVersion {
    
    public var osVersion: OperatingSystemVersion {
        OperatingSystemVersion(majorVersion: major, minorVersion: minor, patchVersion: patch)
    }
    
}

// MARK: - Equatable

extension SoftwareVersion: Equatable { }

// MARK: - Comparable

extension SoftwareVersion: Comparable {
    
    public static func < (lhs: SoftwareVersion, rhs: SoftwareVersion) -> Bool {
        if lhs.major < rhs.major {
            return true
        } else if lhs.major > rhs.major {
            return false
        }
        
        if lhs.minor < rhs.minor {
            return true
        } else if lhs.minor > rhs.minor {
            return false
        }
        
        if lhs.patch < rhs.patch {
            return true
        } else if lhs.patch > rhs.patch {
            return false
        }
        
        return false
    }
    
}

// MARK: - Codable

extension SoftwareVersion: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let versionString = try container.decode(String.self)
        try self.init(string: versionString)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
    
}

// MARK: - InitializationError

extension SoftwareVersion {
    
    enum InitializationError: Error {
        case failedToInitializeRegEx(Error)
        case versionStringDoesNotMatchRegEx(String)
        case unsupportedNumberOfComponents(Int)
    }
    
}
