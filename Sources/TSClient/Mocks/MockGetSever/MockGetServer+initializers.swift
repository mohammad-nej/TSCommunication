//
//  MockGetServer+initializers.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import TSShared
import Foundation
#if os(Linux)
import FoundationNetworking
#endif

public extension MockGetServer{
    
    ///Creates a mock  that runs a closure upon being called
    init<T:OutputableRoute>(for route : T.Type,
                            responds : @Sendable @escaping (URLRequest) async throws -> (O,URLResponse) ) where O == T.OutputData , T : EncoderDecoder{
        if T.self is any FileDownloadable.Type{
            fatalError("Use MockDownloadServer for file downloading")
        }
        self.download = responds
        self.encoder = T.encoder
    }
    
    ///A mock get server that will always responds with a constant value
    init<T:OutputableRoute>(for route : T.Type,
                                   always value : O ) where O == T.OutputData , O : Sendable, T : EncoderDecoder{
        if T.self is any FileDownloadable.Type{
            fatalError("Use MockDownloadServer for file downloading")
        }

        self.download = { _ in
            return (value,URLResponse())
        }
        
        self.encoder = T.encoder
    }
    
    ///Always returns the provided server error
    init<T:OutputableRoute>(for route : T.Type,throws value : T.Failure) where O : Sendable , O == T.Failure{
        
        if T.self is any FileDownloadable.Type{
            fatalError("Use MockDownloadServer for file downloading")
        }

        
        self.download = { _ in
            return (value,URLResponse())
        }
        self.encoder = T.failureEncoder
    }
}
