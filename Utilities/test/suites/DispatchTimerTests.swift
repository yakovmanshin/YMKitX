//
//  DispatchTimerTests.swift
//  YMUtilitiesTests
//
//  Created by Yakov Manshin on 4/23/26.
//  Copyright © 2026 Yakov Manshin. All rights reserved.
//

@testable import YMUtilities

import Dispatch
import Testing

@Suite struct DispatchTimerTests {
    @Test func initWithDefaultArguments() { }
    @Test func initWithCustomArguments() { }
    
    @Test func deinitWithoutStarting() {
        var timer: DispatchTimer? = DispatchTimer()
        weak let dsTimer = timer?.timer
        
        #expect(dsTimer != nil)
        #expect(timer?.state == .suspended)
        
        timer = nil
        #expect(dsTimer == nil)
    }
    
    @Test func deinitWhileRunning() {
        var timer: DispatchTimer? = DispatchTimer()
        weak let dsTimer = timer?.timer
        
        #expect(dsTimer != nil)
        #expect(timer?.state == .suspended)
        
        timer?.start(deadline: .now() + 1) { }
        #expect(dsTimer != nil)
        #expect(timer?.state == .running)
        
        timer = nil
        #expect(dsTimer == nil)
    }
    
    @Test func deinitWhileStopped() {
        var timer: DispatchTimer? = DispatchTimer()
        weak let dsTimer = timer?.timer
        
        #expect(dsTimer != nil)
        #expect(timer?.state == .suspended)
        
        timer?.start(deadline: .now() + 1) { }
        #expect(dsTimer != nil)
        #expect(timer?.state == .running)
        
        timer?.stop()
        #expect(dsTimer != nil)
        #expect(timer?.state == .suspended)
        
        timer = nil
        #expect(dsTimer == nil)
    }
    
    // This scenario is not possible using the public API.
    @Test func deinitWhileCanceled() {
        var timer: DispatchTimer? = DispatchTimer()
        weak let dsTimer = timer?.timer
        
        #expect(dsTimer != nil)
        #expect(timer?.state == .suspended)
        
        timer?.start(deadline: .now() + 1) { }
        #expect(dsTimer != nil)
        #expect(timer?.state == .running)
        
        dsTimer?.cancel()
        #expect(dsTimer != nil)
        
        timer = nil
        #expect(dsTimer == nil)
    }
    
    @Test func stopWithoutStarting() {
        let timer = DispatchTimer()
        #expect(timer.state == .suspended)
        
        timer.stop()
        #expect(timer.state == .suspended)
    }
    
    @Test func immediateRestart() async throws {
        let timer = DispatchTimer()
        #expect(timer.state == .suspended)
        
        var originalHandlerExecuted = false
        timer.start(deadline: .now() + 0.01) {
            originalHandlerExecuted = true
        }
        #expect(timer.state == .running)
        
        timer.stop()
        #expect(timer.state == .suspended)
        
        var newHandlerExecuted = false
        timer.start(deadline: .now() + 0.01) {
            newHandlerExecuted = true
        }
        #expect(timer.state == .running)
        
        try await Task.sleep(nanoseconds: 50 * NSEC_PER_MSEC)
        
        #expect(!originalHandlerExecuted)
        #expect(newHandlerExecuted)
    }
    
    @Test func redundantStart() async throws {
        let timer = DispatchTimer()
        #expect(timer.state == .suspended)
        
        var originalHandlerExecuted = false
        timer.start(deadline: .now() + 0.01) {
            originalHandlerExecuted = true
        }
        #expect(timer.state == .running)
        
        var newHandlerExecuted = false
        timer.start(deadline: .now() + 0.01) {
            newHandlerExecuted = true
        }
        #expect(timer.state == .running)
        
        try await Task.sleep(nanoseconds: 50 * NSEC_PER_MSEC)
        
        #expect(!originalHandlerExecuted)
        #expect(newHandlerExecuted)
    }
    
    @Test func redundantStop() {
        let timer = DispatchTimer()
        #expect(timer.state == .suspended)
        
        timer.start(deadline: .now() + 1) { }
        #expect(timer.state == .running)
        
        timer.stop()
        #expect(timer.state == .suspended)
        
        timer.stop()
        #expect(timer.state == .suspended)
    }
    
    @Test func stopFromHandler() async throws {
        let timer = DispatchTimer()
        #expect(timer.state == .suspended)
        
        timer.start(deadline: .now() + 0.01) {
            timer.stop()
        }
        #expect(timer.state == .running)
        
        try await Task.sleep(nanoseconds: 50 * NSEC_PER_MSEC)
        
        #expect(timer.state == .suspended)
    }
    
    @Test func deadlineTime() { }
    @Test func deadlineWallTime() { }
    
    @Test func pastDeadline() async throws {
        let timer = DispatchTimer()
        #expect(timer.state == .suspended)
        
        var handlerExecuted = false
        timer.start(deadline: .now() - 1) {
            handlerExecuted = true
        }
        #expect(timer.state == .running)
        
        try await Task.sleep(nanoseconds: 1 * NSEC_PER_MSEC)
        
        #expect(handlerExecuted)
    }
    
    @Test func pastWallDeadline() async throws {
        let timer = DispatchTimer()
        #expect(timer.state == .suspended)
        
        var handlerExecuted = false
        timer.start(wallDeadline: .now() - 1) {
            handlerExecuted = true
        }
        #expect(timer.state == .running)
        
        try await Task.sleep(nanoseconds: 1 * NSEC_PER_MSEC)
        
        #expect(handlerExecuted)
    }
    
    @Test func smallInterval() async throws {
        let timer = DispatchTimer()
        #expect(timer.state == .suspended)
        
        var handlerCounter = 0
        timer.start(deadline: .now(), repeating: .milliseconds(1)) {
            handlerCounter += 1
        }
        #expect(timer.state == .running)
        
        try await Task.sleep(nanoseconds: 10 * NSEC_PER_MSEC)
        
        #expect(handlerCounter == 11)
    }
    
    @Test func zeroInterval() async throws {
        let timer = DispatchTimer()
        #expect(timer.state == .suspended)
        
        var handlerCounter = 0
        timer.start(deadline: .now(), repeating: .nanoseconds(0)) {
            handlerCounter += 1
        }
        #expect(timer.state == .running)
        
        try await Task.sleep(nanoseconds: 10 * NSEC_PER_MSEC)
        
        #expect(handlerCounter > 1000)
    }
    
    @Test func negativeInterval() async throws {
        let timer = DispatchTimer()
        #expect(timer.state == .suspended)
        
        var handlerExecuted = false
        timer.start(deadline: .now(), repeating: .seconds(-1)) {
            handlerExecuted = true
        }
        #expect(timer.state == .suspended)
        
        try await Task.sleep(nanoseconds: 1 * NSEC_PER_MSEC)
        
        #expect(timer.state == .suspended)
        #expect(!handlerExecuted)
    }
    
    @Test(arguments: [
        (.never, true),
        (.seconds(30), true),
        (.seconds(0), true),
        (.seconds(-600), false),
        (.milliseconds(100), true),
        (.milliseconds(0), true),
        (.milliseconds(-100), false),
        (.microseconds(10), true),
        (.microseconds(0), true),
        (.microseconds(-10), false),
        (.nanoseconds(1), true),
        (.nanoseconds(0), true),
        (.nanoseconds(-1), false),
    ] as [(DispatchTimeInterval, Bool)]) func isValidInterval(interval: DispatchTimeInterval, expectedResult: Bool) {
        #expect(DispatchTimer.isValidInterval(interval) == expectedResult)
    }
    
    @Test func largeLeeway() { }
    @Test func concurrency() { }
}
