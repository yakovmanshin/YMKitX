//
//  TrackingServiceTests.swift
//  YMMonitoringTests
//
//  Created by Yakov Manshin on 7/20/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

@testable import YMMonitoring

import Foundation
import Testing

struct TrackingServiceTests {
    
    private let service: TrackingService
    private let proxy = TrackingServiceProxyStub()
    
    init() {
        let configuration = TrackingServiceConfiguration(proxy: proxy) { event in
            return TrackingEvent(
                event.name,
                parameters: event.parameters
                    .merging(["TEST_Key1": "TEST_Val1", "TEST_Key2": "TEST_Val2"], uniquingKeysWith: { $1 })
            )
        }
        service = TrackingService(configuration: configuration)
    }
    
    @Test func start_success() async throws {
        try await service.start()
        
        #expect(await service.isTracking)
    }
    
    @Test func start_proxySetupError() async throws {
        let proxyError = NSError(domain: "TEST_Error", code: 123)
        proxy.setUp_result = .failure(proxyError)
        
        let thrownError = try await #require(throws: TrackingService.Error.self) {
            try await service.start()
        }
        
        #expect(await !service.isTracking)
        guard case .proxySetupFailed(let underlyingError) = thrownError else {
            Issue.record(thrownError, "Unexpected error thrown")
            return
        }
        #expect(underlyingError as NSError == proxyError)
        #expect(proxy.setUp_invocationCount == 1)
        #expect(proxy.trackEvent_invocationCount == 0)
    }
    
    @Test func start_queueProcessing() async throws {
        let event = TrackingEvent("TEST_Event1", parameters: ["TEST_event_parameter1": "TEST_event_parameter_value1"])
        try await service.track(event)
        
        await #expect(service.eventQueue.count == 1)
        
        try await service.start()
        
        #expect(await service.isTracking)
        await #expect(service.eventQueue.isEmpty)
        #expect(proxy.setUp_invocationCount == 1)
        #expect(proxy.trackEvent_invocationCount == 1)
        try #require(proxy.trackEvent_events.count == 1)
        #expect(proxy.trackEvent_events[0].name == "TEST_Event1")
        #expect(proxy.trackEvent_events[0].parameters["TEST_event_parameter1"] as? String == "TEST_event_parameter_value1")
    }
    
    @Test func start_queueProcessing_error() async throws {
        let event = TrackingEvent("TEST_Event1", parameters: ["TEST_event_parameter1": "TEST_event_parameter_value1"])
        try await service.track(event)
        let proxyError = NSError(domain: "TEST_Error", code: 123, userInfo: [NSLocalizedDescriptionKey: "TEST_ProxyError"])
        proxy.trackEvent_result = .failure(proxyError)
        
        let thrownError = try await #require(throws: TrackingService.Error.self) {
            try await service.start()
        }
        
        // Even though some events weren't processed, tracking is still running.
        #expect(await service.isTracking)
        guard case .queueProcessingFailed(let underlyingErrors) = thrownError else {
            Issue.record(thrownError, "Unexpected error thrown")
            return
        }
        try #require(underlyingErrors.count == 1)
        #expect(underlyingErrors[0].queuedEvent.name == "TEST_Event1")
        #expect(underlyingErrors[0].queuedEvent.parameters["TEST_event_parameter1"] as? String == "TEST_event_parameter_value1")
        let processingError = try #require(underlyingErrors[0].processingError as? TrackingService.Error)
        guard case .eventProcessingFailed(let underlyingProcessingError) = processingError else {
            Issue.record(processingError, "Unexpected error thrown")
            return
        }
        #expect(underlyingProcessingError as NSError == proxyError)
        #expect(proxy.setUp_invocationCount == 1)
        #expect(proxy.trackEvent_invocationCount == 1)
        #expect(proxy.trackEvent_events.count == 1)
    }
    
    @Test func track_whenTracking() async throws {
        try await service.start()
        let event = TrackingEvent("TEST_Event", parameters: ["TEST_event_parameter": "TEST_event_parameter_value"])
        
        try await service.track(event)
        
        #expect(await service.isTracking)
        await #expect(service.eventQueue.isEmpty)
        try #require(proxy.trackEvent_invocationCount == 1)
        #expect(proxy.trackEvent_events[0].name == "TEST_Event")
        #expect(proxy.trackEvent_events[0].parameters["TEST_event_parameter"] as? String == "TEST_event_parameter_value")
    }
    
    @Test func track_whenNotTracking() async throws {
        let event = TrackingEvent("TEST_Event", parameters: ["TEST_event_parameter": "TEST_event_parameter_value"])
        
        try await service.track(event)
        
        #expect(await !service.isTracking)
        try await #require(service.eventQueue.count == 1)
        await #expect(service.eventQueue[0].name == "TEST_Event")
        await #expect(service.eventQueue[0].parameters["TEST_event_parameter"] as? String == "TEST_event_parameter_value")
        #expect(proxy.trackEvent_invocationCount == 0)
    }
    
    @Test func track_withQueuedEvents() async throws {
        let event1 = TrackingEvent("TEST_Event1", parameters: ["TEST_event_parameter1": "TEST_event_parameter_value1"])
        let event2 = TrackingEvent("TEST_Event2", parameters: ["TEST_event_parameter2": "TEST_event_parameter_value2"])
        let event3 = TrackingEvent("TEST_Event3", parameters: ["TEST_event_parameter3": "TEST_event_parameter_value3"])
        
        try await service.track(event1)
        try await service.track(event2)
        try await service.start()
        try await service.track(event3)
        
        #expect(await service.isTracking)
        await #expect(service.eventQueue.isEmpty)
        #expect(proxy.setUp_invocationCount == 1)
        #expect(proxy.trackEvent_invocationCount == 3)
        try #require(proxy.trackEvent_events.count == 3)
        #expect(proxy.trackEvent_events[0].name == "TEST_Event1")
        #expect(proxy.trackEvent_events[0].parameters["TEST_event_parameter1"] as? String == "TEST_event_parameter_value1")
        #expect(proxy.trackEvent_events[1].name == "TEST_Event2")
        #expect(proxy.trackEvent_events[1].parameters["TEST_event_parameter2"] as? String == "TEST_event_parameter_value2")
        #expect(proxy.trackEvent_events[2].name == "TEST_Event3")
        #expect(proxy.trackEvent_events[2].parameters["TEST_event_parameter3"] as? String == "TEST_event_parameter_value3")
    }
    
//    func test_parametersFromError() async {
//        let error = NSError(
//            domain: "TEST_Error",
//            code: 123,
//            userInfo: ["TEST_error_parameter": "TEST_error_parameter_value"]
//        )
//        
//        let parameters = await service.parametersFromError(error)
//        
//        XCTAssertEqual(parameters["NSError-Code"] as? Int, 123)
//        XCTAssertEqual(parameters["NSError-Domain"] as? String, "TEST_Error")
//        XCTAssertEqual(
//            parameters["NSLocalizedDescription"] as? String,
//            "The operation couldn’t be completed. (TEST_Error error 123.)"
//        )
//    }
    
    @Test func prepareEvent_noParameters() async {
        let originalEvent = TrackingEvent("TEST_Event")
        
        let event = await service.prepareEvent(from: originalEvent)
        
        #expect(event.parameters["TEST_Key1"] as? String == "TEST_Val1")
        #expect(event.parameters["TEST_Key2"] as? String == "TEST_Val2")
    }
    
    @Test func prepareEvent_shortParameters() async {
        let originalEvent = TrackingEvent("TEST_Event", parameters: ["TEST_event_parameter": "TEST_event_parameter_value"])
        
        let event = await service.prepareEvent(from: originalEvent)
        
        #expect(event.parameters["TEST_event_parameter"] as? String == "TEST_event_parameter_value")
        #expect(event.parameters["TEST_Key1"] as? String == "TEST_Val1")
        #expect(event.parameters["TEST_Key2"] as? String == "TEST_Val2")
    }
    
    @Test func prepareEvent_longParameters() async {
        let originalEvent = TrackingEvent("TEST_Event", parameters: [
            "TEST_event_parameter": "TEST_event_parameter_long_value_event_parameter_long_value_event_parameter_long_value_event_parameter_long_value_event_parameter_long_value_event_parameter_long_value_event_parameter_long_value_event_parameter_long_value_event_parameter_long_value_event_parameter_long_value_"
        ])
        
        let event = await service.prepareEvent(from: originalEvent)
        
        #expect(
            event.parameters["TEST_event_parameter"] as? String ==
            "TEST_event_parameter_long_value_event_parameter_long_value_event_parameter_long_value_event_paramet…"
        )
        #expect(event.parameters["TEST_Key1"] as? String == "TEST_Val1")
        #expect(event.parameters["TEST_Key2"] as? String == "TEST_Val2")
    }
    
}
