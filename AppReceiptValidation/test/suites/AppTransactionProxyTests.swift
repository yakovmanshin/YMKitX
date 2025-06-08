//
//  AppTransactionProxyTests.swift
//  YMAppReceiptValidationTests
//
//  Created by Yakov Manshin on 6/7/25.
//  Copyright © 2025 Yakov Manshin. All rights reserved.
//

@testable import YMAppReceiptValidation

import Testing

struct AppTransactionProxyTests {
    
    @Test(arguments: [
        (.production, "Production"),
        (.sandbox, "Sandbox"),
        (.xcode, "Xcode"),
        (.other("TEST_Env1"), "TEST_Env1"),
        (.other(""), ""),
    ] as [(AppTransactionProxy.Environment, String)])
    func environment_rawValue(env: AppTransactionProxy.Environment, rawValue: String) {
        #expect(env.rawValue == rawValue)
    }
    
}
