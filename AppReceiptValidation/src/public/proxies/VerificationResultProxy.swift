//
//  VerificationResultProxy.swift
//  YMAppReceiptValidation
//
//  Created by Yakov Manshin on 10/31/23.
//  Copyright © 2023 Yakov Manshin. All rights reserved.
//

public enum VerificationResultProxy<Payload: Sendable>: Sendable {
    case verified(Payload)
    case unverified(Payload, any Error)
}

extension VerificationResultProxy {
    
    var verifiedPayload: Payload? {
        switch self {
        case .verified(let payload): payload
        case .unverified: nil
        }
    }
    
}
