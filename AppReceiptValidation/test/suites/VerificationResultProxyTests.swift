//
//  VerificationResultProxyTests.swift
//  YMAppReceiptValidationTests
//
//  Created by Yakov Manshin on 6/7/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

@testable import YMAppReceiptValidation

import Foundation
import Testing

struct VerificationResultProxyTests {
    
    @Test func verifiedPayload_verified() {
        let proxy = VerificationResultProxy.verified(123)
        
        #expect(proxy.verifiedPayload == 123)
    }
    
    @Test func verifiedPayload_unverified() {
        let proxy = VerificationResultProxy.unverified(123, NSError(domain: "TEST_Error", code: 999))
        
        #expect(proxy.verifiedPayload == nil)
    }
    
}
