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
    
    func log(for category: LogCategory, level: LogLevel, _ message: String) async {
        logger(for: category).log(level: level, message)
    }
    
    func logError(_ error: any Error, for category: LogCategory) {
        logger(for: category).logError(error)
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
        debugPrint("No logger implementation is available for the current platform. Logs will be sent to stdout.")
        return StandardOutputWrapper()
        #endif
    }
    
}

// MARK: - LoggerImplementationWrapper

private protocol LoggerImplementationWrapper {
    func log(level: LogLevel, _ message: String)
    func logError(_ error: any Error)
}

#if canImport(os)

@inline(__always) fileprivate func osLogType(from logLevel: LogLevel) -> OSLogType {
    switch logLevel {
    case .debug: .debug
    case .info: .info
    case .default: .default
    case .error: .error
    case .fault: .fault
    }
}

// MARK: - LoggerWrapper

@available(iOS 14, macOS 11, *)
final private class LoggerWrapper: LoggerImplementationWrapper {
    
    private let logger: os.Logger
    
    init(logger: os.Logger) {
        self.logger = logger
    }
    
    func log(level: LogLevel, _ message: String) {
        logger.log(level: osLogType(from: level), "\(message, privacy: .public)")
    }
    
    func logError(_ error: any Error) {
        logger.error("Error: \(error.localizedDescription, privacy: .public)")
    }
    
}

// MARK: - OSLogWrapper

final private class OSLogWrapper: LoggerImplementationWrapper {
    
    private let log: OSLog
    
    init(log: OSLog) {
        self.log = log
    }
    
    func log(level: LogLevel, _ message: String) {
        os_log(osLogType(from: level), log: log, "%{public}@", message)
    }
    
    func logError(_ error: any Error) {
        os_log(.error, log: log, "Error: %{public}@", error.localizedDescription)
    }
    
}

 #else

// MARK: - StandardOutputWrapper

final private class StandardOutputWrapper: LoggerImplementationWrapper {
    
    func log(level: LogLevel, _ message: String) {
        let levelString = "\(level)".uppercased()
        print("\(levelString): \(message)")
    }
    
    func logError(_ error: any Error) {
        print("Error: \(error.localizedDescription)")
    }
    
}

#endif
