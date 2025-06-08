//
//  YMAppValidation.swift
//  YMAppValidation
//
//  Created by Yakov Manshin on 6/7/25.
//  Copyright © 2025 Yakov Manshin. All rights reserved.
//

import YMAppReceiptValidation

/// Initializes and returns an opaque-type app validator.
public func makeAppValidator() -> some AppValidatorProtocol {
    AppValidator(appReceiptValidator: makeAppReceiptValidator())
}
