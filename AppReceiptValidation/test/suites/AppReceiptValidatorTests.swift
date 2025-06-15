//
//  AppReceiptValidatorTests.swift
//  YMAppReceiptValidationTests
//
//  Created by Yakov Manshin on 11/3/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

@testable import YMAppReceiptValidation

import Foundation
import Testing
import YMUtilities

// MARK: - Tests

struct AppReceiptValidatorTests {
    
    let validator: AppReceiptValidator<AppReceiptValidatorProxyStub>
    let proxy = AppReceiptValidatorProxyStub()
    
    init() {
        validator = AppReceiptValidator(proxy: proxy, appIdentity: .sample)
    }
    
    @Test func validateAppReceipt_allowUI_success_shared() async {
        proxy.getSharedVerificationResult_result = .success(.verified(.sample))
        proxy.getDeviceVerificationID_result = .allZero
        
        let report = await validator.validateAppReceipt()
        
        #expect(proxy.getSharedVerificationResult_invocationCount == 1)
        #expect(proxy.refreshVerificationResult_invocationCount == 0)
        #expect(proxy.getDeviceVerificationID_invocationCount == 1)
        guard case .success = report.result else {
            Issue.record()
            return
        }
        #expect(report.transaction == .sample)
    }
    
    @Test func validateAppReceipt_noUI_success() async {
        proxy.getSharedVerificationResult_result = .success(.verified(.sample))
        proxy.getDeviceVerificationID_result = .allZero
        
        let report = await validator.validateAppReceipt(allowUI: false)
        
        #expect(proxy.getSharedVerificationResult_invocationCount == 1)
        #expect(proxy.refreshVerificationResult_invocationCount == 0)
        #expect(proxy.getDeviceVerificationID_invocationCount == 1)
        guard case .success = report.result else {
            Issue.record()
            return
        }
        #expect(report.transaction == .sample)
    }
    
    @Test func validateAppReceipt_allowUI_success_refreshed() async {
        proxy.getSharedVerificationResult_result = .failure(NSError(domain: "TEST_Error", code: 123))
        proxy.refreshVerificationResult_result = .success(.verified(.sample))
        proxy.getDeviceVerificationID_result = .allZero
        
        let report = await validator.validateAppReceipt()
        
        #expect(proxy.getSharedVerificationResult_invocationCount == 1)
        #expect(proxy.refreshVerificationResult_invocationCount == 1)
        #expect(proxy.getDeviceVerificationID_invocationCount == 1)
        guard case .success = report.result else {
            Issue.record()
            return
        }
        #expect(report.transaction == .sample)
    }
    
    @Test func validateAppReceipt_allowUI_failure_transaction() async {
        proxy.getSharedVerificationResult_result = .failure(NSError(domain: "TEST_Error", code: 123))
        let refreshVerificationError = NSError(domain: "TEST_Error", code: 456)
        proxy.refreshVerificationResult_result = .success(.unverified(.sample, refreshVerificationError))
        
        let report = await validator.validateAppReceipt()
        
        #expect(proxy.getSharedVerificationResult_invocationCount == 1)
        #expect(proxy.refreshVerificationResult_invocationCount == 1)
        #expect(proxy.getDeviceVerificationID_invocationCount == 0)
        guard case .failure(let error) = report.result else {
            Issue.record()
            return
        }
        guard case .unverifiedTransaction(let error) = error else {
            Issue.record()
            return
        }
        #expect(error as NSError == refreshVerificationError)
        #expect(report.transaction == .sample)
    }
    
    @Test func validateAppReceipt_noUI_failure_transaction() async {
        let sharedVerificationError = NSError(domain: "TEST_Error", code: 123)
        proxy.getSharedVerificationResult_result = .success(.unverified(.sample, sharedVerificationError))
        
        let report = await validator.validateAppReceipt(allowUI: false)
        
        #expect(proxy.getSharedVerificationResult_invocationCount == 1)
        #expect(proxy.refreshVerificationResult_invocationCount == 0)
        #expect(proxy.getDeviceVerificationID_invocationCount == 0)
        guard case .failure(let error) = report.result else {
            Issue.record()
            return
        }
        guard case .unverifiedTransaction(let error) = error else {
            Issue.record()
            return
        }
        #expect(error as NSError == sharedVerificationError)
        #expect(report.transaction == .sample)
    }
    
    @Test func validateAppReceipt_allowUI_failure_device() async {
        proxy.getSharedVerificationResult_result = .success(.verified(.sample))
        proxy.getDeviceVerificationID_result = .nonZero
        
        let report = await validator.validateAppReceipt()
        
        #expect(proxy.getSharedVerificationResult_invocationCount == 1)
        #expect(proxy.refreshVerificationResult_invocationCount == 0)
        #expect(proxy.getDeviceVerificationID_invocationCount == 1)
        guard case .failure(let error) = report.result else {
            Issue.record()
            return
        }
        guard case let .deviceVerificationMismatch(expected: expected, actual: actual) = error else {
            Issue.record()
            return
        }
        #expect(expected == "215990702201e1faf7e3f6fc2134cca64eb369c29a2f01414cab34912e28d8d0931d1ab518ec6213ffc01203c3406af3")
        #expect(actual == "7d30e01f8fd318434b2f5ac0a49936d14eac344505ef789fa89a8a57b5e181a0f23827d610107e0f4defe5214f9f6130")
        #expect(report.transaction == .sample)
    }
    
    @Test func validateAppReceipt_noUI_failure_device() async {
        proxy.getSharedVerificationResult_result = .success(.verified(.sample))
        proxy.getDeviceVerificationID_result = .nonZero
        
        let report = await validator.validateAppReceipt(allowUI: false)
        
        #expect(proxy.getSharedVerificationResult_invocationCount == 1)
        #expect(proxy.refreshVerificationResult_invocationCount == 0)
        #expect(proxy.getDeviceVerificationID_invocationCount == 1)
        guard case .failure(let error) = report.result else {
            Issue.record()
            return
        }
        guard case let .deviceVerificationMismatch(expected: expected, actual: actual) = error else {
            Issue.record()
            return
        }
        #expect(expected == "215990702201e1faf7e3f6fc2134cca64eb369c29a2f01414cab34912e28d8d0931d1ab518ec6213ffc01203c3406af3")
        #expect(actual == "7d30e01f8fd318434b2f5ac0a49936d14eac344505ef789fa89a8a57b5e181a0f23827d610107e0f4defe5214f9f6130")
        #expect(report.transaction == .sample)
    }
    
    @Test func validateAppReceipt_allowUI_failure_unavailable() async {
        proxy.getSharedVerificationResult_result = .failure(NSError(domain: "TEST_Error", code: 123))
        let refreshVerificationResultError = NSError(domain: "TEST_Error", code: 456)
        proxy.refreshVerificationResult_result = .failure(refreshVerificationResultError)
        
        let report = await validator.validateAppReceipt()
        
        #expect(proxy.getSharedVerificationResult_invocationCount == 1)
        #expect(proxy.refreshVerificationResult_invocationCount == 1)
        #expect(proxy.getDeviceVerificationID_invocationCount == 0)
        guard case .failure(let error) = report.result else {
            Issue.record()
            return
        }
        guard case .verificationResultUnavailable(let error) = error else {
            Issue.record()
            return
        }
        #expect(error as NSError? == refreshVerificationResultError)
        #expect(report.transaction == nil)
    }
    
    @Test func validateAppReceipt_noUI_failure_unavailable() async {
        let sharedVerificationResultError = NSError(domain: "TEST_Error", code: 123)
        proxy.getSharedVerificationResult_result = .failure(sharedVerificationResultError)
        
        let report = await validator.validateAppReceipt(allowUI: false)
        
        #expect(proxy.getSharedVerificationResult_invocationCount == 1)
        #expect(proxy.refreshVerificationResult_invocationCount == 0)
        #expect(proxy.getDeviceVerificationID_invocationCount == 0)
        guard case .failure(let error) = report.result else {
            Issue.record()
            return
        }
        guard case .verificationResultUnavailable(let error) = error else {
            Issue.record()
            return
        }
        #expect(error as NSError? == sharedVerificationResultError)
        #expect(report.transaction == nil)
    }
    
    @available(iOS 16, *)
    @Test func getVerifiedTransaction_shared_verified() async {
        proxy.getSharedVerificationResult_result = .success(.verified(.sample))
        
        let (transaction, error) = await validator.getVerifiedTransaction()
        
        #expect(proxy.getSharedVerificationResult_invocationCount == 1)
        #expect(proxy.refreshVerificationResult_invocationCount == 0)
        #expect(proxy.getDeviceVerificationID_invocationCount == 0)
        #expect(transaction == .sample)
        #expect(error == nil)
    }
    
    @available(iOS 16, *)
    @Test func getVerifiedTransaction_shared_unverified() async {
        let sharedVerificationError = NSError(domain: "TEST_Error", code: 123)
        proxy.getSharedVerificationResult_result = .success(.unverified(.sample, sharedVerificationError))
        proxy.refreshVerificationResult_result = .success(.verified(.sample))
        
        let (transaction, error) = await validator.getVerifiedTransaction()
        
        #expect(proxy.getSharedVerificationResult_invocationCount == 1)
        #expect(proxy.refreshVerificationResult_invocationCount == 1)
        #expect(proxy.getDeviceVerificationID_invocationCount == 0)
        #expect(transaction == .sample)
        #expect(error == nil)
    }
    
    @available(iOS 16, *)
    @Test func getVerifiedTransaction_refresh_verified() async {
        let sharedVerificationResultError = NSError(domain: "TEST_Error", code: 123)
        proxy.getSharedVerificationResult_result = .failure(sharedVerificationResultError)
        proxy.refreshVerificationResult_result = .success(.verified(.sample))
        
        let (transaction, error) = await validator.getVerifiedTransaction()
        
        #expect(proxy.getSharedVerificationResult_invocationCount == 1)
        #expect(proxy.refreshVerificationResult_invocationCount == 1)
        #expect(proxy.getDeviceVerificationID_invocationCount == 0)
        #expect(transaction == .sample)
        #expect(error == nil)
    }
    
    @available(iOS 16, *)
    @Test func getVerifiedTransaction_refresh_unverified() async {
        let sharedVerificationError = NSError(domain: "TEST_Error", code: 123)
        proxy.getSharedVerificationResult_result = .success(.unverified(.sample, sharedVerificationError))
        let refreshVerificationError = NSError(domain: "TEST_Error", code: 456)
        proxy.refreshVerificationResult_result = .success(.unverified(.sample, refreshVerificationError))
        
        let (transaction, error) = await validator.getVerifiedTransaction()
        
        #expect(proxy.getSharedVerificationResult_invocationCount == 1)
        #expect(proxy.refreshVerificationResult_invocationCount == 1)
        #expect(proxy.getDeviceVerificationID_invocationCount == 0)
        #expect(transaction == .sample)
        guard case .unverifiedTransaction(let error) = error else {
            Issue.record()
            return
        }
        #expect(error as NSError == refreshVerificationError)
    }
    
    @available(iOS 16, *)
    @Test func getVerifiedTransaction_refreshed_unavailable() async {
        let sharedVerificationResultError = NSError(domain: "TEST_Error", code: 123)
        proxy.getSharedVerificationResult_result = .failure(sharedVerificationResultError)
        let refreshVerificationResultError = NSError(domain: "TEST_Error", code: 456)
        proxy.refreshVerificationResult_result = .failure(refreshVerificationResultError)
        
        let (transaction, error) = await validator.getVerifiedTransaction()
        
        #expect(proxy.getSharedVerificationResult_invocationCount == 1)
        #expect(proxy.refreshVerificationResult_invocationCount == 1)
        #expect(proxy.getDeviceVerificationID_invocationCount == 0)
        #expect(transaction == nil)
        guard case .verificationResultUnavailable(let error) = error else {
            Issue.record()
            return
        }
        #expect(error as NSError == refreshVerificationResultError)
    }
    
    @available(iOS 16, *)
    @Test func verifyDevice_success() async throws {
        proxy.getDeviceVerificationID_result = .allZero
        
        try await validator.verifyDevice(for: .sample)
        
        #expect(proxy.getDeviceVerificationID_invocationCount == 1)
    }
    
    @available(iOS 16, *)
    @Test func verifyDevice_failure_deviceVerificationIDUnavailable() async throws {
        let error = try await #require(throws: AppReceiptValidatorError.self) {
            try await validator.verifyDevice(for: .sample)
        }
        
        #expect(proxy.getDeviceVerificationID_invocationCount == 1)
        guard case .deviceVerificationIDUnavailable = error else {
            Issue.record()
            return
        }
    }
    
    @available(iOS 16, *)
    @Test func verifyDevice_failure_deviceVerificationMismatch() async throws {
        proxy.getDeviceVerificationID_result = .nonZero
        
        let error = try await #require(throws: AppReceiptValidatorError.self) {
            try await validator.verifyDevice(for: .sample)
        }
        
        #expect(proxy.getDeviceVerificationID_invocationCount == 1)
        guard case let .deviceVerificationMismatch(expected: expected, actual: actual) = error else {
            Issue.record()
            return
        }
        #expect(expected == "215990702201e1faf7e3f6fc2134cca64eb369c29a2f01414cab34912e28d8d0931d1ab518ec6213ffc01203c3406af3")
        #expect(actual == "7d30e01f8fd318434b2f5ac0a49936d14eac344505ef789fa89a8a57b5e181a0f23827d610107e0f4defe5214f9f6130")
    }
    
    @Test func verifyAppIdentity_success() async throws {
        try await validator.verifyAppIdentity(for: .sample)
    }
    
    @Test func verifyAppIdentity_success_skipped() async throws {
        let validator = AppReceiptValidator(proxy: proxy, appIdentity: nil)
        
        try await validator.verifyAppIdentity(for: .sample)
    }
    
    @Test func verifyAppIdentity_failure_bundleID() async throws {
        let transaction = AppTransactionProxy(
            bundleID: "TEST_AnotherBundleID",
            environment: .production,
            appVersion: "1.23.45",
            originalAppVersion: "",
            purchaseDate: Date(),
            deviceVerificationNonce: .allZero,
            deviceVerification: Data()
        )
        
        let error = try await #require(throws: AppReceiptValidatorError.self) {
            try await validator.verifyAppIdentity(for: transaction)
        }
        guard case .other = error else {
            Issue.record()
            return
        }
    }
    
    @Test func verifyAppIdentity_failure_appVersion() async throws {
        let transaction = AppTransactionProxy(
            bundleID: "TEST_BundleID",
            environment: .sandbox,
            appVersion: "10.0.0",
            originalAppVersion: "",
            purchaseDate: Date(),
            deviceVerificationNonce: .allZero,
            deviceVerification: Data()
        )
        
        let error = try await #require(throws: AppReceiptValidatorError.self) {
            try await validator.verifyAppIdentity(for: transaction)
        }
        guard case .other = error else {
            Issue.record()
            return
        }
    }
    
}

// MARK: - Utilities

fileprivate extension AppTransactionProxy {
    
    static let sample = AppTransactionProxy(
        bundleID: "TEST_BundleID",
        environment: .other("TEST_Environment"),
        appVersion: "1.23.45",
        originalAppVersion: "TEST_OriginalAppVersion",
        purchaseDate: Date(timeIntervalSince1970: 1521288000),
        deviceVerificationNonce: .allZero,
        deviceVerification: Data([
            0x21, 0x59, 0x90, 0x70, 0x22, 0x01, 0xe1, 0xfa,
            0xf7, 0xe3, 0xf6, 0xfc, 0x21, 0x34, 0xcc, 0xa6,
            0x4e, 0xb3, 0x69, 0xc2, 0x9a, 0x2f, 0x01, 0x41,
            0x4c, 0xab, 0x34, 0x91, 0x2e, 0x28, 0xd8, 0xd0,
            0x93, 0x1d, 0x1a, 0xb5, 0x18, 0xec, 0x62, 0x13,
            0xff, 0xc0, 0x12, 0x03, 0xc3, 0x40, 0x6a, 0xf3,
        ]),
    )
    
}

extension AppTransactionProxy: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.bundleID == rhs.bundleID &&
        lhs.environment == rhs.environment &&
        lhs.appVersion == rhs.appVersion &&
        lhs.originalAppVersion == rhs.originalAppVersion &&
        lhs.purchaseDate == rhs.purchaseDate &&
        lhs.deviceVerificationNonce == rhs.deviceVerificationNonce &&
        lhs.deviceVerification == rhs.deviceVerification
    }
    
}

extension AppTransactionProxy.Environment: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.production, .production), (.sandbox, .sandbox), (.xcode, .xcode): true
        case let (.other(lhs), .other(rhs)): lhs == rhs
        default: false
        }
    }
    
}

fileprivate extension UUID {
    static let allZero = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
    static let nonZero = UUID(uuidString: "01234567-89AB-CDEF-0123-456789ABCDEF")!
}

fileprivate extension AppIdentity {
    static let sample = AppIdentity(bundleIdentifier: "TEST_BundleID", version: SoftwareVersion("1.23.45")!)
}
