//
//  ServerBig+defaults.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/29/26.
//


import TSShared

public extension ServerLargeFileUploadable {
    static  var transferMethod: FileTransferMethod { .stream }
    
    static var method: HttpMethod { .POST }
}
