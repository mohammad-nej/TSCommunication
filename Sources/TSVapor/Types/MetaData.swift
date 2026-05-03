//
//  _MetaDAta.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/25/26.
//

import Vapor

///used for receiving content of a multipart request
public struct _MetaData : Content {
    public let metaData : String
    public let file : File
    
    public init(metaData: String, file: File) {
        self.metaData = metaData
        self.file = file
    }
}
