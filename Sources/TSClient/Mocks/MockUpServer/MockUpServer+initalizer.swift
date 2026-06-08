//
//  MockUpServer+initalizer.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import TSShared
import Foundation
#if os(Linux)
import FoundationNetworking
#endif

public extension MockUpServer{
    ///Creates a mock  that runs a closure upon being called
    init<T:OutputableRoute>(for route : T.Type,
                            uploadData : @Sendable @escaping (Data,URLRequest) async throws -> (Out,URLResponse),
                            
    ) where T.OutputData == Out , T:EncoderDecoder {
        self.uploadData = uploadData
        self.encoder = T.encoder
    }
    
    ///Always returns the provided value
    init<T:OutputableRoute>(for route : T.Type,
                            always value : Out) where Out : Sendable,T:EncoderDecoder {
        self.uploadData = { _, _ in
            return (value,URLResponse())
        }
        
        self.encoder = T.encoder
        
    }
    
    ///Always returns the provided server error
    init<T:OutputableRoute>(for route : T.Type,throws value : T.Failure) where Out : Sendable,T.Failure == Out{
        self.uploadData = { _, _ in
            return (value,URLResponse())
        }
        self.encoder = T.failureEncoder
    }
    
}


