//
//  AppReceiptValidatorReport.swift
//  YMAppReceiptValidation
//
//  Created by Yakov Manshin on 11/2/23.
//  Copyright © 2023 Yakov Manshin. All rights reserved.
//

/// The app-receipt-validation report.
public struct AppReceiptValidatorReport: Sendable {
    
    /// The app-receipt validation result.
    public let result: Result<Void, AppReceiptValidatorError>
    
    /// The app transaction, returned as is.
    ///
    /// + Even if transaction verification fails, this property may be not `nil`. Don’t rely on data in this object unless `result` is `success`.
    public let transaction: AppTransactionProxy?
    
}
