//
//  IOStatus.swift
//  YMMisc
//
//  Created by Yakov Manshin on 7/16/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

#if canImport(IOKit)

import IOKit

// MARK: - Status

public enum IOStatus: Equatable, Sendable {
    
    case success
    
    case aborted
    case badArgument
    case badMedia
    case badMessageID
    case busy
    case cannotLock
    case cannotWire
    case deviceError
    case dmaError
    case error
    case exclusiveAccess
    case internalError
    case invalid
    case ioError
    case ipcError
    case isoTooNew
    case isoTooOld
    case lockedRead
    case lockedWrite
    case messageTooLarge
    case noBandwidth
    case noChannels
    case noCompletion
    case noDevice
    case noFrames
    case noInterrupt
    case noMedia
    case noMemory
    case noPower
    case noResources
    case noSpace
    case notAligned
    case notAttached
    case notFound
    case notOpen
    case notPermitted
    case notPrivileged
    case notReadable
    case notReady
    case notResponding
    case notWritable
    case offline
    case overrun
    case portExists
    case rldError
    case stillOpen
    case timeout
    case underrun
    case unformattedMedia
    case unsupported
    case unsupportedMode
    case vmError
    
    case other(IOReturn)
    
}

// MARK: - IOReturn

extension IOStatus {
    
    public init(ioReturn: IOReturn) {
        switch ioReturn {
        case kIOReturnSuccess:          self = .success
        case kIOReturnAborted:          self = .aborted
        case kIOReturnBadArgument:      self = .badArgument
        case kIOReturnBadMedia:         self = .badMedia
        case kIOReturnBadMessageID:     self = .badMessageID
        case kIOReturnBusy:             self = .busy
        case kIOReturnCannotLock:       self = .cannotLock
        case kIOReturnCannotWire:       self = .cannotWire
        case kIOReturnDeviceError:      self = .deviceError
        case kIOReturnDMAError:         self = .dmaError
        case kIOReturnError:            self = .error
        case kIOReturnExclusiveAccess:  self = .exclusiveAccess
        case kIOReturnInternalError:    self = .internalError
        case kIOReturnInvalid:          self = .invalid
        case kIOReturnIOError:          self = .ioError
        case kIOReturnIPCError:         self = .ipcError
        case kIOReturnIsoTooNew:        self = .isoTooNew
        case kIOReturnIsoTooOld:        self = .isoTooOld
        case kIOReturnLockedRead:       self = .lockedRead
        case kIOReturnLockedWrite:      self = .lockedWrite
        case kIOReturnMessageTooLarge:  self = .messageTooLarge
        case kIOReturnNoBandwidth:      self = .noBandwidth
        case kIOReturnNoChannels:       self = .noChannels
        case kIOReturnNoCompletion:     self = .noCompletion
        case kIOReturnNoDevice:         self = .noDevice
        case kIOReturnNoFrames:         self = .noFrames
        case kIOReturnNoInterrupt:      self = .noInterrupt
        case kIOReturnNoMedia:          self = .noMedia
        case kIOReturnNoMemory:         self = .noMemory
        case kIOReturnNoPower:          self = .noPower
        case kIOReturnNoResources:      self = .noResources
        case kIOReturnNoSpace:          self = .noSpace
        case kIOReturnNotAligned:       self = .notAligned
        case kIOReturnNotAttached:      self = .notAttached
        case kIOReturnNotFound:         self = .notFound
        case kIOReturnNotOpen:          self = .notOpen
        case kIOReturnNotPermitted:     self = .notPermitted
        case kIOReturnNotPrivileged:    self = .notPrivileged
        case kIOReturnNotReadable:      self = .notReadable
        case kIOReturnNotReady:         self = .notReady
        case kIOReturnNotResponding:    self = .notResponding
        case kIOReturnNotWritable:      self = .notWritable
        case kIOReturnOffline:          self = .offline
        case kIOReturnOverrun:          self = .overrun
        case kIOReturnPortExists:       self = .portExists
        case kIOReturnRLDError:         self = .rldError
        case kIOReturnStillOpen:        self = .stillOpen
        case kIOReturnTimeout:          self = .timeout
        case kIOReturnUnderrun:         self = .underrun
        case kIOReturnUnformattedMedia: self = .unformattedMedia
        case kIOReturnUnsupported:      self = .unsupported
        case kIOReturnUnsupportedMode:  self = .unsupportedMode
        case kIOReturnVMError:          self = .vmError
        default:                        self = .other(ioReturn)
        }
    }
    
}

#endif
