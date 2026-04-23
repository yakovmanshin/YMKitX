//
//  DispatchTimer.swift
//  YMUtilities
//
//  Created by Yakov Manshin on 4/21/26.
//  Copyright © 2026 Yakov Manshin. All rights reserved.
//

import Dispatch

@propertyWrapper
class DispatchTimer {
    
    var wrappedValue: DispatchTimer { self }
    
    @available(*, unavailable, message: "Evolution")
    var projectedValue: any DispatchSourceTimer { timer }
    
    private let timer: any DispatchSourceTimer
    private var state = State.suspended
    
    @available(*, unavailable, message: "Evolution")
    convenience init(queueLabel: String? = nil) {
        let queue: DispatchQueue? = if let queueLabel {
            DispatchQueue(label: queueLabel)
        } else { nil }
        
        self.init(queue: queue)
    }
    
    init(queue: DispatchQueue? = nil, isStrict: Bool = false) {
        timer = DispatchSource.makeTimerSource(flags: isStrict ? .strict : [], queue: queue)
    }
    
    deinit {
        timer.cancel()
        timer.resume()
        state = .canceled
    }
    
    func start(
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
    
    func start(
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
    
    func stop() {
        guard state == .running else { return }
        timer.suspend()
        state = .suspended
    }
    
}

extension DispatchTimer {
    
    enum State {
        case suspended, running, canceled
    }
    
}
