//
//  AppReceiptValidatorProxy.swift
//  YMAppReceiptValidation
//
//  Created by Yakov Manshin on 10/31/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

import StoreKit

final class AppReceiptValidatorProxy: AppReceiptValidatorProxyProtocol {
    
    @available(iOS 16, *)
    @available(macOS 13, *)
    func getSharedVerificationResult() async throws -> VerificationResultProxy<AppTransactionProxy> {
        try await verificationResult(from: AppTransaction.shared)
    }
    
    @available(iOS 16, *)
    @available(macOS 13, *)
    func refreshVerificationResult() async throws -> VerificationResultProxy<AppTransactionProxy> {
        try await verificationResult(from: AppTransaction.refresh())
    }
    
    @available(iOS 16, *)
    @available(macOS 13, *)
    private func verificationResult(
        from result: VerificationResult<AppTransaction>
    ) -> VerificationResultProxy<AppTransactionProxy> {
        switch result {
            case .verified(let transaction): .verified(AppTransactionProxy(transaction))
            case let .unverified(transaction, error): .unverified(AppTransactionProxy(transaction), error)
        }
    }
    
    @available(iOS 15, *)
    @available(macOS 12, *)
    func getDeviceVerificationID() -> UUID? {
        AppStore.deviceVerificationID
    }
    
}
