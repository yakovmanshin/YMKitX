//
//  YMAppReceiptValidation.swift
//  YMAppReceiptValidation
//
//  Created by Yakov Manshin on 6/7/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

/// Initializes and returns an opaque-type app-receipt validator.
///
/// - Parameter appIdentity: *Optional.* The object which describes the checked app’s identity.
/// If no value is provided, app-identity verification will be skipped.
public func makeAppReceiptValidator(appIdentity: AppIdentity? = nil) -> some AppReceiptValidatorProtocol {
    AppReceiptValidator(
        proxy: AppReceiptValidatorProxy(),
        appIdentity: appIdentity,
    )
}
