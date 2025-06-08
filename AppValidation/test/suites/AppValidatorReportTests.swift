//
//  AppValidatorReportTests.swift
//  YMAppValidationTests
//
//  Created by Yakov Manshin on 6/7/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

@testable import YMAppReceiptValidation
@testable import YMAppValidation

import Foundation
import Testing

struct AppValidatorReportTests {
    
    @Test func success_true() {
        let report = AppValidatorReport(components: [
            .appReceipt(.init(result: .success(()), transaction: nil)),
        ])
        
        #expect(report.success)
    }
    
    @Test func success_false() {
        let report = AppValidatorReport(components: [
            .appReceipt(.init(result: .failure(.other), transaction: nil)),
        ])
        
        #expect(!report.success)
    }
    
    @Test func errors_empty() {
        let report = AppValidatorReport(components: [
            .appReceipt(.init(result: .success(()), transaction: nil)),
        ])
        
        #expect(report.errors.isEmpty)
    }
    
    @Test func errors_notEmpty() {
        let appReceiptError = AppReceiptValidatorError.other
        let report = AppValidatorReport(components: [
            .appReceipt(.init(result: .failure(.other), transaction: nil)),
        ])
        
        #expect(report.errors.count == 1)
        #expect(report.errors[0] as NSError == appReceiptError as NSError)
    }
    
}
