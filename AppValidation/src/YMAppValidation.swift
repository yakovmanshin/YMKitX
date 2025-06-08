//
//  YMAppValidation.swift
//  YMAppValidation
//
//  Created by Yakov Manshin on 6/7/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

import YMAppReceiptValidation

/// Initializes and returns an opaque-type app validator.
public func makeAppValidator() -> some AppValidatorProtocol {
    AppValidator(appReceiptValidator: makeAppReceiptValidator())
}
