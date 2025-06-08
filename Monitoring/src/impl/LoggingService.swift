//
//  LoggingService.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 8/14/20.
//  Copyright © 2020 Yakov Manshin. See the LICENSE file for license info.
//

#if canImport(os)
import os
#endif

// MARK: - LoggingService

final actor LoggingService {
    
    private let configuration: LoggingServiceConfiguration
    private var loggers = [LogCategory: any LoggerImplementationWrapper]()
    
    init(configuration: LoggingServiceConfiguration) {
        self.configuration = configuration
    }
    
}

// MARK: - LoggingServiceProtocol

extension LoggingService: LoggingServiceProtocol {
    
    func log(for category: LogCategory, _ message: String) {
        logger(for: category).log(message)
    }
    
    func logError(_ error: any Error, for category: LogCategory) {
        logger(for: category).logError(error)
    }
    
    func logError(for category: LogCategory, _ message: String) {
        logger(for: category).logError(message)
    }
    
    private func logger(for category: LogCategory) -> any LoggerImplementationWrapper {
        if let logger = loggers[category] {
            return logger
        } else {
            let logger = makeLogger(for: category)
            loggers[category] = logger
            return logger
        }
    }
    
    private func makeLogger(for category: LogCategory) -> any LoggerImplementationWrapper {
        #if canImport(os)
        if #available(iOS 14, macOS 11, *) {
            let logger = switch category {
            case .default: os.Logger(subsystem: configuration.subsystem, category: configuration.defaultCategory)
            case .custom(let category): os.Logger(subsystem: configuration.subsystem, category: category)
            }
            return LoggerWrapper(logger: logger)
        } else {
            let log = switch category {
            case .default: OSLog(subsystem: configuration.subsystem, category: configuration.defaultCategory)
            case .custom(let category): OSLog(subsystem: configuration.subsystem, category: category)
            }
            return OSLogWrapper(log: log)
        }
        #else
        debugPrint("No logger implementation is available on this platform")
        #endif
    }
    
}

// MARK: - LoggerImplementationWrapper

private protocol LoggerImplementationWrapper {
    func log(_ message: String)
    func logError(_ error: any Error)
    func logError(_ message: String)
}

#if canImport(os)

// MARK: - LoggerWrapper

@available(iOS 14, macOS 11, *)
final private class LoggerWrapper: LoggerImplementationWrapper {
    
    private let logger: os.Logger
    
    init(logger: os.Logger) {
        self.logger = logger
    }
    
    func log(_ message: String) {
        logger.log("\(message, privacy: .public)")
    }
    
    func logError(_ error: any Error) {
        logger.error("Error: \(error.localizedDescription, privacy: .public)")
    }
    
    func logError(_ message: String) {
        logger.error("Error: \(message, privacy: .public)")
    }
    
}

// MARK: - OSLogWrapper

final private class OSLogWrapper: LoggerImplementationWrapper {
    
    private let log: OSLog
    
    init(log: OSLog) {
        self.log = log
    }
    
    func log(_ message: String) {
        os_log(.default, log: log, "%{public}@", message)
    }
    
    func logError(_ error: any Error) {
        os_log(.error, log: log, "Error: %{public}@", error.localizedDescription)
    }
    
    func logError(_ message: String) {
        os_log(.error, log: log, "Error: %{public}@", message)
    }
    
}

#endif
