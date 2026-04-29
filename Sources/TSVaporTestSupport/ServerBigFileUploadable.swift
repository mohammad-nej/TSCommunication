//
//  ServerBigFileUploadable.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/29/26.
//

import TSVapor
import TSShared
import VaporTesting





public extension ServerBigFileUploadable {
    static func upload(_ data : Data , in  request : inout TestingHTTPRequest){
        request.body = ByteBuffer(data:data)
    }
}



