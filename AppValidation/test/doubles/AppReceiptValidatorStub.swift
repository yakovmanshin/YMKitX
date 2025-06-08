//
//  AppReceiptValidatorStub.swift
//  YMAppValidationTests
//
//  Created by Yakov Manshin on 11/3/23.
//  Copyright © 2023 Yakov Manshin. All rights reserved.
//

import YMAppReceiptValidation

final class AppReceiptValidatorStub {
    
    nonisolated(unsafe) var validateAppReceipt_invocationCount = 0
    nonisolated(unsafe) var validateAppReceipt_allowUI = [Bool]()
    nonisolated(unsafe) var validateAppReceipt_result: AppReceiptValidatorReport!
    
}

extension AppReceiptValidatorStub: AppReceiptValidatorProtocol {
    
    func validateAppReceipt(allowUI: Bool = true) async -> AppReceiptValidatorReport {
        validateAppReceipt_invocationCount += 1
        validateAppReceipt_allowUI.append(allowUI)
        return validateAppReceipt_result
    }
    
}
