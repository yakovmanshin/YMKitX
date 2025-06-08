//
//  AppReceiptValidatorProtocol.swift
//  YMAppReceiptValidation
//
//  Created by Yakov Manshin on 9/25/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

/// The object that validates app receipts.
public protocol AppReceiptValidatorProtocol: Sendable {
    
    /// Validates the app receipt and returns the report.
    ///
    /// - Parameter allowUI: *Required.* Indicates whether the validator is allowed to present user-interface elements (e.g. prompts).
    func validateAppReceipt(allowUI: Bool) async -> AppReceiptValidatorReport
    
}
