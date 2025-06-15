//
//  YMAppValidation.swift
//  YMAppValidation
//
//  Created by Yakov Manshin on 6/7/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

import YMAppReceiptValidation

/// Initializes and returns an opaque-type app validator.
///
/// - Parameter appIdentity: *Optional.* The object which describes the checked app’s identity.
/// If no value is provided, app-identity verification will be skipped.
public func makeAppValidator(appIdentity: AppIdentity? = nil) -> some AppValidatorProtocol {
    AppValidator(appReceiptValidator: makeAppReceiptValidator(appIdentity: appIdentity))
}
