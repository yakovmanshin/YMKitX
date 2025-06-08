//
//  YMAppReceiptValidation.swift
//  YMAppReceiptValidation
//
//  Created by Yakov Manshin on 6/7/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

/// Initializes and returns an opaque-type app-receipt validator.
public func makeAppReceiptValidator() -> some AppReceiptValidatorProtocol {
    AppReceiptValidator(proxy: AppReceiptValidatorProxy())
}
