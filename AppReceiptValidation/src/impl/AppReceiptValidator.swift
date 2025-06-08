//
//  AppReceiptValidator.swift
//  YMAppReceiptValidation
//
//  Created by Yakov Manshin on 9/25/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

import CryptoKit

// MARK: - AppReceiptValidator

final actor AppReceiptValidator<Proxy: AppReceiptValidatorProxyProtocol> {
    
    private let proxy: Proxy
    
    init(proxy: Proxy) {
        self.proxy = proxy
    }
    
}

// MARK: - AppReceiptValidatorProtocol

extension AppReceiptValidator: AppReceiptValidatorProtocol {
    
    func validateAppReceipt(allowUI: Bool = true) async -> AppReceiptValidatorReport {
        guard #available(iOS 16, macOS 13, *) else {
            return .init(result: .failure(.unsupportedPlatform), transaction: nil)
        }
        
        let verifiedTransaction: AppTransactionProxy
        switch await getVerifiedTransaction(allowUI: allowUI) {
        case (.some(let transaction), nil):
            verifiedTransaction = transaction
        case let (transaction, .some(error)):
            return .init(result: .failure(error), transaction: transaction)
        case (nil, nil):
            return .init(result: .failure(.other), transaction: nil)
        }
        
        do {
            try verifyDevice(for: verifiedTransaction)
        } catch {
            return .init(result: .failure(error), transaction: verifiedTransaction)
        }
        
        return .init(result: .success(()), transaction: verifiedTransaction)
    }
    
    @available(iOS 16, *)
    @available(macOS 13, *)
    func getVerifiedTransaction(allowUI: Bool = true) async -> (AppTransactionProxy?, AppReceiptValidatorError?) {
        var (transaction, transactionError) = await getTransaction(using: proxy.getSharedVerificationResult)
        if transaction != nil, transactionError == nil {
            return (transaction, transactionError)
        }
        
        if allowUI {
            (transaction, transactionError) = await getTransaction(using: proxy.refreshVerificationResult)
        }
        
        return (transaction, transactionError)
    }
    
    @available(iOS 16, *)
    @available(macOS 13, *)
    private func getTransaction(
        using closure: () async throws -> VerificationResultProxy<AppTransactionProxy>
    ) async -> (AppTransactionProxy?, AppReceiptValidatorError?) {
        do {
            switch try await closure() {
            case .verified(let transaction): return (transaction, nil)
            case let .unverified(transaction, error): return (transaction, .unverifiedTransaction(error))
            }
        } catch {
            return (nil, .verificationResultUnavailable(error))
        }
    }
    
    @available(iOS 16, *)
    @available(macOS 13, *)
    func verifyDevice(for transaction: AppTransactionProxy) throws(AppReceiptValidatorError) {
        guard let verificationID = proxy.getDeviceVerificationID() else {
            throw .deviceVerificationIDUnavailable
        }
        
        let verificationNonce = transaction.deviceVerificationNonce
        
        let verificationString = verificationNonce.uuidString.lowercased() + verificationID.uuidString.lowercased()
        guard let verificationData = verificationString.data(using: .utf8) else {
            throw .invalidDeviceVerificationString(verificationString)
        }
        
        let computedVerification = SHA384.hash(data: verificationData)
        
        guard computedVerification == transaction.deviceVerification else {
            throw .deviceVerificationMismatch(
                expected: formattedString(fromBytes: transaction.deviceVerification),
                actual: formattedString(fromBytes: computedVerification),
            )
        }
    }
    
    private func formattedString<BS: Sequence>(fromBytes byteSequence: BS) -> String where BS.Element == UInt8 {
        byteSequence.map({ String(format: "%02x", $0) }).joined()
    }
    
}
