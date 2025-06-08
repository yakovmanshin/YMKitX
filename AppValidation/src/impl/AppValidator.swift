//
//  AppValidator.swift
//  YMAppValidation
//
//  Created by Yakov Manshin on 9/26/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

import YMAppReceiptValidation

// MARK: - AppValidator

final actor AppValidator<ARV: AppReceiptValidatorProtocol> {
    
    var cachedReport: AppValidatorReport?
    
    private let appReceiptValidator: ARV
    
    init(appReceiptValidator: ARV) {
        self.appReceiptValidator = appReceiptValidator
    }
    
}

// MARK: - AppValidatorProtocol

extension AppValidator: AppValidatorProtocol {
    
    func validateApp(allowCache: Bool, allowUI: Bool) async -> AppValidatorReport {
        if allowCache, let cachedReport {
            return cachedReport
        }
        
        let appReceiptReport = await appReceiptValidator.validateAppReceipt(allowUI: allowUI)
        
        let report = AppValidatorReport(components: [
            .appReceipt(appReceiptReport),
        ])
        
        if allowCache {
            cachedReport = report
        }
        
        return report
    }
    
}
