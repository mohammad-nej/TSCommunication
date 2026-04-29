//
//  ServerBig+defaults.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/29/26.
//


import TSShared

public extension ServerBigFileUploadable {
    static  var transferMethod: FileTransferMethod { .stream }
    
    static public var method: HttpMethod { .post }
}
