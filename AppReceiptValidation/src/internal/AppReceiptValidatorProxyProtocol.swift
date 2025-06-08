//
//  AppReceiptValidatorProxyProtocol.swift
//  YMAppReceiptValidation
//
//  Created by Yakov Manshin on 10/31/23.
//  Copyright © 2023 Yakov Manshin. All rights reserved.
//

import Foundation

protocol AppReceiptValidatorProxyProtocol: Sendable {
    
    @available(iOS 16, *)
    @available(macOS 13, *)
    func getSharedVerificationResult() async throws -> VerificationResultProxy<AppTransactionProxy>
    
    @available(iOS 16, *)
    @available(macOS 13, *)
    func refreshVerificationResult() async throws -> VerificationResultProxy<AppTransactionProxy>
    
    @available(iOS 15, *)
    @available(macOS 12, *)
    func getDeviceVerificationID() -> UUID?
    
}
