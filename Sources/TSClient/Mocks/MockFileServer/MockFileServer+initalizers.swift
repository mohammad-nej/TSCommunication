//
//  MockFileServer+initalizers.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import TSShared
import Foundation

public extension MockFileServer {
    init<T : ClientBigFileUploadable>(for route : T.Type ,
                                             uploadFile: @Sendable @escaping (URL,URLRequest) async throws -> (Out, URLResponse)
    ) where T.OutputData == Out{
        self.uploadFile = uploadFile
        self.encoder = T.encoder
    }
    
    
    init<T:ClientBigFileUploadable>(for route : T.Type,
                            always value : Out) where Out : Sendable{
     
        self.uploadFile = { _, _ in
            return (value,URLResponse())
        }
        self.encoder = T.encoder
        
    }

}