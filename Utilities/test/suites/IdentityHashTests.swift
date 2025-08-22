//
//  IdentityHashTests.swift
//  YMUtilitiesTests
//
//  Created by Yakov Manshin on 3/23/25.
//  Copyright © 2025 Yakov Manshin. All rights reserved.
//

@testable import YMUtilities

import Testing

struct IdentityHashTests {
    
    @Test func hashCalculation() {
        let object = IdentityHashTestObject()
        let memoryPointer = Unmanaged.passUnretained(object).toOpaque()
        
        let identityHash = IdentityHash(object)
        
        #expect(identityHash._hashValue == memoryPointer.hashValue)
    }
    
}

private class IdentityHashTestObject { }
