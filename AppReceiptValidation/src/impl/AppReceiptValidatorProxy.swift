//
//  AppReceiptValidatorProxy.swift
//  YMAppReceiptValidation
//
//  Created by Yakov Manshin on 10/31/23.
//  Copyright © 2023 Yakov Manshin. All rights reserved.
//

import StoreKit

final class AppReceiptValidatorProxy: AppReceiptValidatorProxyProtocol {
    
    @available(iOS 16, *)
    @available(macOS 13, *)
    func getSharedVerificationResult() async throws -> VerificationResultProxy<AppTransactionProxy> {
        switch try await AppTransaction.shared {
        case .verified(let transaction): .verified(AppTransactionProxy(transaction))
        case let .unverified(transaction, error): .unverified(AppTransactionProxy(transaction), error)
        }
    }
    
    @available(iOS 16, *)
    @available(macOS 13, *)
    func refreshVerificationResult() async throws -> VerificationResultProxy<AppTransactionProxy> {
        switch try await AppTransaction.refresh() {
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
