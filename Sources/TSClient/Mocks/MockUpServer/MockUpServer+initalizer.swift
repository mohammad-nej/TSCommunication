//
//  MockUpServer+initalizer.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import TSShared
import Foundation


public extension MockUpServer{
    ///Creates a mock  that runs a closure upon being called
    init<T:ClientHttpRoute>(for route : T.Type,
                            uploadData : @Sendable @escaping (Data,URLRequest) async throws -> (Out,URLResponse),
                            
    ) where T.OutputData == Out {
        self.uploadData = uploadData
        self.encoder = T.encoder
    }
    
    ///Always returns the provided value
    init<T:ClientHttpRoute>(for route : T.Type,
                            always value : Out) where Out : Sendable{
        self.uploadData = { _, _ in
            return (value,URLResponse())
        }
        
        self.encoder = T.encoder
        
    }
}
