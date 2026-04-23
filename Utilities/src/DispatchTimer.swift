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
    
    @available(*, unavailable, message: "Evolution")
    public var projectedValue: any DispatchSourceTimer { timer }
    
    let timer: any DispatchSourceTimer
    private(set) var state = State.suspended
    
    @available(*, unavailable, message: "Evolution")
    public convenience init(queueLabel: String? = nil) {
        let queue: DispatchQueue? = if let queueLabel {
            DispatchQueue(label: queueLabel)
        } else { nil }
        
        self.init(queue: queue)
    }
    
    public init(queue: DispatchQueue? = nil, isStrict: Bool = false) {
        timer = DispatchSource.makeTimerSource(flags: isStrict ? .strict : [], queue: queue)
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
        guard state != .canceled else { return }
        if state == .running { stop() }
        
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
        guard state != .canceled else { return }
        if state == .running { stop() }
        
        timer.schedule(wallDeadline: wallDeadline, repeating: interval, leeway: leeway)
        timer.setEventHandler(handler: handler)
        timer.resume()
        state = .running
    }
    
    public func stop() {
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
