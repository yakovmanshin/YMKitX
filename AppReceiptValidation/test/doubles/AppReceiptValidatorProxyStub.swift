//
//  AppReceiptValidatorProxyStub.swift
//  YMAppReceiptValidationTests
//
//  Created by Yakov Manshin on 11/3/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

@testable import YMAppReceiptValidation

import Foundation

final class AppReceiptValidatorProxyStub {
    
    nonisolated(unsafe) var getSharedVerificationResult_invocationCount = 0
    nonisolated(unsafe) var getSharedVerificationResult_result: Result<VerificationResultProxy<AppTransactionProxy>, any Error>!
    
    nonisolated(unsafe) var refreshVerificationResult_invocationCount = 0
    nonisolated(unsafe) var refreshVerificationResult_result: Result<VerificationResultProxy<AppTransactionProxy>, any Error>!
    
    nonisolated(unsafe) var getDeviceVerificationID_invocationCount = 0
    nonisolated(unsafe) var getDeviceVerificationID_result: UUID?
    
}

extension AppReceiptValidatorProxyStub: AppReceiptValidatorProxyProtocol {
    
    func getSharedVerificationResult() async throws -> VerificationResultProxy<AppTransactionProxy> {
        getSharedVerificationResult_invocationCount += 1
        switch getSharedVerificationResult_result! {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
    
    func refreshVerificationResult() async throws -> VerificationResultProxy<AppTransactionProxy> {
        refreshVerificationResult_invocationCount += 1
        switch refreshVerificationResult_result! {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
    
    func getDeviceVerificationID() -> UUID? {
        getDeviceVerificationID_invocationCount += 1
        return getDeviceVerificationID_result
    }
    
}
