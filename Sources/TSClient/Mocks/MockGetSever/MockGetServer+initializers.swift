//
//  MockGetServer+initializers.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import TSShared
import Foundation

public extension MockGetServer{
    
    ///A mock GET server that can responds to clients
    init<T:ClientGetRouteProtocol>(for route : T.Type,
                             responds : @Sendable @escaping (URLRequest) async throws -> (O,URLResponse) ) where O == T.OutputData{
        
        self.download = responds
        self.encoder = T.encoder
    }
    
    ///A mock get server that will always responds with a constant value
    init<T:ClientGetRouteProtocol>(for route : T.Type,
                                   always value : O ) where O == T.OutputData , O : Sendable{
        
        self.download = { _ in
            return (value,URLResponse())
        }
        self.encoder = T.encoder
    }

    
}