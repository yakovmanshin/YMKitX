//
//  AppValidatorProtocol.swift
//  YMAppValidation
//
//  Created by Yakov Manshin on 9/25/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

/// The object that validates the app.
public protocol AppValidatorProtocol: Sendable {
    
    /// Performs app validation and returns the final report.
    func performValidation() async -> AppValidatorReport
    
    /// Validates the app and returns the report.
    ///
    /// - Parameter allowCache: *Required.* Indicates whether the validator is allowed to return cached reports.
    /// - Parameter allowUI: *Required.* Indicates whether the validator is allowed to present user-interface elements.
    func validateApp(allowCache: Bool, allowUI: Bool) async -> AppValidatorReport
    
}
