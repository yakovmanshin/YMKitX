//
//  MonitoringService+ErrorWrapper.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 9/13/24.
//  Copyright © 2024 Yakov Manshin. See the LICENSE file for license info.
//

import Foundation

extension MonitoringService {
    
    struct ErrorWrapper: Error, LocalizedError {
        let message: String
        var errorDescription: String? { message }
    }
    
}
