//
//  Logger.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation
import os.log

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    case critical = "CRITICAL"
}

struct Logger {
    static let osLog = OSLog(subsystem: "com.forge.oreforge", category: "OreForge")

    static func debug(_ message: String, file: String = #file, line: Int = #line) {
        log(message, level: .debug, file: file, line: line)
    }

    static func info(_ message: String, file: String = #file, line: Int = #line) {
        log(message, level: .info, file: file, line: line)
    }

    static func warning(_ message: String, file: String = #file, line: Int = #line) {
        log(message, level: .warning, file: file, line: line)
    }

    static func error(_ message: String, file: String = #file, line: Int = #line) {
        log(message, level: .error, file: file, line: line)
    }

    static func critical(_ message: String, file: String = #file, line: Int = #line) {
        log(message, level: .critical, file: file, line: line)
    }

    private static func log(_ message: String, level: LogLevel, file: String, line: Int) {
        let filename = URL(fileURLWithPath: file).lastPathComponent
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let formattedMessage = "[\(timestamp)] [\(level.rawValue)] [\(filename):\(line)] \(message)"

        #if DEBUG
        print(formattedMessage)
        #endif

        let osLogType: OSLogType = {
            switch level {
            case .debug: return .debug
            case .info: return .info
            case .warning: return .default
            case .error: return .error
            case .critical: return .error
            }
        }()

        os_log("%@", log: osLog, type: osLogType, formattedMessage)
    }
}
