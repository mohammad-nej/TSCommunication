//
//  MockGetServer+initializers.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import TSShared
import Foundation

public extension MockGetServer{
    
    ///Creates a mock  that runs a closure upon being called
    init<T:OutputableRoute>(for route : T.Type,
                            responds : @Sendable @escaping (URLRequest) async throws -> (O,URLResponse) ) where O == T.OutputData , T : EncoderDecoder{
        
        self.download = responds
        self.encoder = T.encoder
    }
    
    ///A mock get server that will always responds with a constant value
    init<T:OutputableRoute>(for route : T.Type,
                                   always value : O ) where O == T.OutputData , O : Sendable, T : EncoderDecoder{
        
        self.download = { _ in
            return (value,URLResponse())
        }
        self.encoder = T.encoder
    }

    init<T:OutputableRoute>(for route : T.Type,throws value : T.Failure) where O : Sendable , O == T.Failure{
        self.download = { _ in
            return (value,URLResponse())
        }
        self.encoder = T.failureEncoder
    }
}
