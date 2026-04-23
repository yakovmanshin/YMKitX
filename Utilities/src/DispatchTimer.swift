//
//  DispatchTimer.swift
//  YMUtilities
//
//  Created by Yakov Manshin on 4/21/26.
//  Copyright © 2026 Yakov Manshin. All rights reserved.
//

import Dispatch

// MARK: - Timer

@propertyWrapper
public class DispatchTimer {
    
    public var wrappedValue: DispatchTimer { self }
    
    private let queue: DispatchQueue
    let timer: any DispatchSourceTimer
    private(set) var state = State.suspended
    
    public init(queue: DispatchQueue? = nil, isStrict: Bool = false) {
        timer = DispatchSource.makeTimerSource(flags: isStrict ? .strict : [], queue: queue)
        self.queue = DispatchQueue(label: "YMKitX.DispatchTimer.\(UInt.random(in: (.min)...(.max)))")
    }
    
    deinit {
        stop()
        timer.cancel()
        timer.resume()
        state = .canceled
    }
    
    public func start(
        deadline: DispatchTime,
        repeating interval: DispatchTimeInterval = .never,
        leeway: DispatchTimeInterval = .never,
        handler: @escaping () -> Void
    ) {
        queue.sync { _start(deadline: deadline, repeating: interval, leeway: leeway, handler: handler) }
    }
    
    private func _start(
        deadline: DispatchTime,
        repeating interval: DispatchTimeInterval = .never,
        leeway: DispatchTimeInterval = .never,
        handler: @escaping () -> Void
    ) {
        guard state != .canceled, Self.isValidInterval(interval) else { return }
        if state == .running { _stop() }
        
        timer.schedule(deadline: deadline, repeating: interval, leeway: leeway)
        timer.setEventHandler(handler: handler)
        timer.resume()
        state = .running
    }
    
    public func start(
        wallDeadline: DispatchWallTime,
        repeating interval: DispatchTimeInterval = .never,
        leeway: DispatchTimeInterval = .never,
        handler: @escaping () -> Void
    ) {
        queue.sync { _start(wallDeadline: wallDeadline, repeating: interval, leeway: leeway, handler: handler) }
    }
    
    private func _start(
        wallDeadline: DispatchWallTime,
        repeating interval: DispatchTimeInterval = .never,
        leeway: DispatchTimeInterval = .never,
        handler: @escaping () -> Void
    ) {
        guard state != .canceled, Self.isValidInterval(interval) else { return }
        if state == .running { _stop() }
        
        timer.schedule(wallDeadline: wallDeadline, repeating: interval, leeway: leeway)
        timer.setEventHandler(handler: handler)
        timer.resume()
        state = .running
    }
    
    static func isValidInterval(_ interval: DispatchTimeInterval) -> Bool {
        switch interval {
        case .seconds(let value), .milliseconds(let value), .microseconds(let value), .nanoseconds(let value):
            if value > 0 {
                return true
            } else if value == 0 {
                print("[YMKitX / DispatchTimer] Using zero as the repeat interval may cause unexpected results; the timer will start anyway")
                return true
            } else {
                print("[YMKitX / DispatchTimer] Using a negative repeat interval causes a runtime exception; the timer will not start")
                return false
            }
        case .never: return true
        @unknown default:
            print("[YMKitX / DispatchTimer] Unknown DispatchTimeInterval value; you may need to update YMKitX")
            return true
        }
    }
    
    public func stop() {
        queue.sync { _stop() }
    }
    
    private func _stop() {
        guard state == .running else { return }
        timer.suspend()
        state = .suspended
    }
    
}

// MARK: - State

extension DispatchTimer {
    
    enum State {
        case suspended, running, canceled
    }
    
}
