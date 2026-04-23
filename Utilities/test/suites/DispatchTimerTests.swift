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
    
    @Test func deinitWhileRunning() { }
    @Test func deinitWhileStopped() { }
    @Test func deinitWhileCanceled() { }
    @Test func redundantStart() { }
    @Test func redundantStop() { }
    @Test func stopFromHandler() { }
    @Test func immediateRestart() { }
    @Test func deadlineTime() { }
    @Test func deadlineWallTime() { }
    @Test func pastDeadline() { }
    @Test func zeroInterval() { }
    @Test func negativeInterval() { }
    @Test func largeLeeway() { }
    @Test func concurrency() { }
}
