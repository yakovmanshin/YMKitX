//
//  ValidationComponent.swift
//  YMAppValidation
//
//  Created by Yakov Manshin on 2/17/26.
//  Copyright © 2026 Yakov Manshin. See the LICENSE file for license info.
//

public protocol ValidationComponent {
    associatedtype Error: Swift.Error
    func isSupported() async -> Bool
    func performValidation() async -> Result<Void, Error>
}
