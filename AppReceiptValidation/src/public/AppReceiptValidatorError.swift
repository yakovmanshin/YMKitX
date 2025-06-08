//
//  AppReceiptValidatorError.swift
//  YMAppReceiptValidation
//
//  Created by Yakov Manshin on 9/25/23.
//  Copyright © 2023 Yakov Manshin. All rights reserved.
//

import Foundation

/// Errors returned by the app-receipt validator.
public enum AppReceiptValidatorError: Error {
    
    /// The platform version does not support app-receipt validation.
    case unsupportedPlatform
    
    /// Failed to retrieve a transaction-verification result.
    case verificationResultUnavailable(any Error)
    
    /// The transaction is explicitly unverified.
    case unverifiedTransaction(any Error)
    
    /// Failed to retrieve the device-verification ID.
    case deviceVerificationIDUnavailable
    
    /// Failed to initialize device-verification data from the string.
    case invalidDeviceVerificationString(String)
    
    /// Device-verification tags don’t match.
    case deviceVerificationMismatch(expected: String, actual: String)
    
    /// Other (unexpected) error.
    ///
    /// + This error is never expected to be thrown.
    case other
    
}

extension AppReceiptValidatorError: CustomStringConvertible, LocalizedError {
    
    public var description: String {
        switch self {
        case .unsupportedPlatform:
            "The platform version does not support app-receipt validation"
        case .verificationResultUnavailable(let error):
            "Verification result is unavailable: \(error.localizedDescription)"
        case .unverifiedTransaction(let error):
            "The transaction is unverified: \(error.localizedDescription)"
        case .deviceVerificationIDUnavailable:
            "Device-verification ID is not available"
        case .invalidDeviceVerificationString(let string):
            "Invalid device-verification string: \(string)"
        case .deviceVerificationMismatch(let expected, let actual):
            "Device-verification data mismatched: expected (\(expected.prefix(16))…) / computed (\(actual.prefix(16))…)"
        case .other:
            "An unknown error occurred"
        }
    }
    
    public var errorDescription: String? { description }
    
}
