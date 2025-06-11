//
//  Timestamp.swift
//  YMUtilities
//
//  Created by Yakov Manshin on 1/21/21.
//  Copyright © 2021 Yakov Manshin. See the LICENSE file for license info.
//

import Foundation

// MARK: - Timestamp

public struct Timestamp: Sendable {
    
    let timeInterval: TimeInterval
    
    init(_ timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    public init(from date: Date) {
        timeInterval = date.timeIntervalSince1970
    }
    
    public var seconds: Int {
        Int(timeInterval)
    }
    
    public var date: Date {
        Date(timeIntervalSince1970: timeInterval)
    }
    
}

// MARK: - Equatable

extension Timestamp: Equatable { }

// MARK: - Comparable

extension Timestamp: Comparable {
    
    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        lhs.timeInterval < rhs.timeInterval
    }
    
}

// MARK: - ExpressibleByIntegerLiteral

extension Timestamp: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: IntegerLiteralType) {
        timeInterval = TimeInterval(value)
    }
    
}

// MARK: - Codable

extension Timestamp: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        timeInterval = try container.decode(TimeInterval.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(timeInterval)
    }
    
}
