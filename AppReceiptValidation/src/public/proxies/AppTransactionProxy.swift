//
//  AppTransactionProxy.swift
//  YMAppReceiptValidation
//
//  Created by Yakov Manshin on 10/31/23.
//  Copyright © 2023 Yakov Manshin. All rights reserved.
//

import StoreKit

// MARK: - Proxy

public struct AppTransactionProxy: Sendable {
    public let bundleID: String
    public let environment: Environment
    public let appVersion: String
    public let originalAppVersion: String
    public let purchaseDate: Date
    public let deviceVerificationNonce: UUID
    public let deviceVerification: Data
}

// MARK: - Environment

extension AppTransactionProxy {
    
    public enum Environment: Sendable {
        case production
        case sandbox
        case xcode
        case other(String)
    }
    
}

extension AppTransactionProxy.Environment {
    
    var rawValue: String {
        switch self {
        case .production: "Production"
        case .sandbox: "Sandbox"
        case .xcode: "Xcode"
        case .other(let environmentName): environmentName
        }
    }
    
}

// MARK: - StoreKit

extension AppTransactionProxy {
    
    @available(iOS 16, *)
    @available(macOS 13, *)
    init(_ transaction: AppTransaction) {
        self.init(
            bundleID: transaction.bundleID,
            environment: Environment(transaction.environment),
            appVersion: transaction.appVersion,
            originalAppVersion: transaction.originalAppVersion,
            purchaseDate: transaction.originalPurchaseDate,
            deviceVerificationNonce: transaction.deviceVerificationNonce,
            deviceVerification: transaction.deviceVerification,
        )
    }
    
}

extension AppTransactionProxy.Environment {
    
    @available(iOS 16, *)
    @available(macOS 13, *)
    init(_ environment: AppStore.Environment) {
        self = switch environment {
        case .production: .production
        case .sandbox: .sandbox
        case .xcode: .xcode
        default: .other(environment.rawValue)
        }
    }
    
}
