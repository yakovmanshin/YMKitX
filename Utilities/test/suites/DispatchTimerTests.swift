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
        
        #expect(originalHandlerExecuted == false)
        #expect(newHandlerExecuted == true)
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
        
        #expect(originalHandlerExecuted == false)
        #expect(newHandlerExecuted == true)
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
        
        #expect(handlerExecuted == true)
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
        
        #expect(handlerExecuted == true)
    }
    
    @Test func zeroInterval() { }
    @Test func negativeInterval() { }
    @Test func largeLeeway() { }
    @Test func concurrency() { }
}
