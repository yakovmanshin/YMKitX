//
//  AppValidatorReport.swift
//  YMAppValidation
//
//  Created by Yakov Manshin on 7/29/24.
//  Copyright © 2024 Yakov Manshin. See the LICENSE file for license info.
//

import YMAppReceiptValidation

// MARK: - Report

/// The app-validation report.
public struct AppValidatorReport: Sendable {
    
    /// The array of validated components.
    public let components: [Component]
    
}

extension AppValidatorReport {
    
    /// Returns `true` if all components have passed validation.
    public var success: Bool {
        errors.isEmpty
    }
    
    /// Returns type-erased errors returned by validated components.
    public var errors: [any Error] {
        components.compactMap { component in
            switch component {
            case .appReceipt(let report):
                if case .failure(let error) = report.result {
                    return error
                }
            }
            
            return nil
        }
    }
    
}

// MARK: - Component

extension AppValidatorReport {
    
    public enum Component: Sendable {
        case appReceipt(AppReceiptValidatorReport)
    }
    
}
