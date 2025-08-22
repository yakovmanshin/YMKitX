//
//  IdentityHash.swift
//  YMUtilities
//
//  Created by Yakov Manshin on 4/10/22.
//  Copyright © 2022 Yakov Manshin. All rights reserved.
//

// MARK: - IdentityHash

public struct IdentityHash {
    
    let _hashValue: Int
    
    public init(_ object: AnyObject) {
        _hashValue = Self.hashValue(of: object)
    }
    
    private static func hashValue(of object: AnyObject) -> Int {
        let address = Unmanaged.passUnretained(object).toOpaque()
        return address.hashValue
    }
    
}

// MARK: - Hashable

extension IdentityHash: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_hashValue)
    }
    
}
