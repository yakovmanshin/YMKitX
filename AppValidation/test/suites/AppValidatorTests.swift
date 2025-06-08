//
//  AppValidatorTests.swift
//  YMAppValidationTests
//
//  Created by Yakov Manshin on 11/3/23.
//  Copyright © 2023 Yakov Manshin. All rights reserved.
//

@testable import YMAppReceiptValidation
@testable import YMAppValidation

import Foundation
import Testing

// MARK: - Tests

struct AppValidatorTests {
    
    let validator: AppValidator<AppReceiptValidatorStub>
    let appReceiptValidator = AppReceiptValidatorStub()
    
    init() {
        validator = AppValidator(appReceiptValidator: appReceiptValidator)
    }
    
    @Test func validateApp_withCache() async {
        let cachedReport = AppValidatorReport(components: [
            .appReceipt(AppReceiptValidatorReport(result: .success(()), transaction: nil)),
        ])
        await validator.setCachedReport(cachedReport)
        
        let report = await validator.validateApp(allowCache: true, allowUI: true)
        
        #expect(appReceiptValidator.validateAppReceipt_invocationCount == 0)
        #expect(report.components.count == 1)
        guard case .appReceipt(let appReceiptReport) = report.components.first else {
            Issue.record()
            return
        }
        guard case .success = appReceiptReport.result else {
            Issue.record()
            return
        }
    }
    
    @Test func validateApp_noCache() async {
        let appReceiptReport1 = AppReceiptValidatorReport(result: .success(()), transaction: nil)
        let cachedReport = AppValidatorReport(components: [.appReceipt(appReceiptReport1)])
        await validator.setCachedReport(cachedReport)
        let appReceiptReport2 = AppReceiptValidatorReport(result: .failure(.other), transaction: nil)
        appReceiptValidator.validateAppReceipt_result = appReceiptReport2
        
        let report = await validator.validateApp(allowCache: false, allowUI: true)
        
        #expect(appReceiptValidator.validateAppReceipt_invocationCount == 1)
        #expect(report.components.count == 1)
        guard case .appReceipt(let appReceiptReport) = report.components.first else {
            Issue.record()
            return
        }
        guard case .failure(let error) = appReceiptReport.result else {
            Issue.record()
            return
        }
        #expect(error as NSError == AppReceiptValidatorError.other as NSError)
    }
    
    @Test func validateApp_withUI() async {
        appReceiptValidator.validateAppReceipt_result = AppReceiptValidatorReport(result: .success(()), transaction: nil)
        
        _ = await validator.validateApp(allowCache: true, allowUI: true)
        
        #expect(appReceiptValidator.validateAppReceipt_invocationCount == 1)
        #expect(appReceiptValidator.validateAppReceipt_allowUI == [true])
    }
    
    @Test func validateApp_noUI() async {
        appReceiptValidator.validateAppReceipt_result = AppReceiptValidatorReport(result: .success(()), transaction: nil)
        
        _ = await validator.validateApp(allowCache: true, allowUI: false)
        
        #expect(appReceiptValidator.validateAppReceipt_invocationCount == 1)
        #expect(appReceiptValidator.validateAppReceipt_allowUI == [false])
    }
    
}

// MARK: - Utilities

extension AppValidator {
    
    func setCachedReport(_ report: AppValidatorReport) {
        cachedReport = report
    }
    
}
