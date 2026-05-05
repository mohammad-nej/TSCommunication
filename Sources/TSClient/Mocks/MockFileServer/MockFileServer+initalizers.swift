//
//  MockFileServer+initalizers.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import TSShared
import Foundation

public extension MockFileServer {
    
    ///Creates a mock  that runs a closure upon being called
    init<T : ClientLargeFileUploadable>(for route : T.Type ,
                                             uploadFile: @Sendable @escaping (URL,URLRequest) async throws -> (Out, URLResponse)
    ) where T.OutputData == Out{
        self.uploadFile = uploadFile
        self.encoder = T.encoder
    }
    
    ///Always returns the provided value
    init<T:ClientLargeFileUploadable>(for route : T.Type,
                            always value : Out) where Out : Sendable{
     
        self.uploadFile = { _, _ in
            return (value,URLResponse())
        }
        self.encoder = T.encoder
        
    }

    ///Always returns the provided server error
    init<T:ClientLargeFileUploadable>(for route : T.Type,throws value : T.Failure) where Out : Sendable , Out == T.Failure{
        self.uploadFile = { _, _ in
            return (value,URLResponse())
        }
        self.encoder = T.failureEncoder
    }
}
