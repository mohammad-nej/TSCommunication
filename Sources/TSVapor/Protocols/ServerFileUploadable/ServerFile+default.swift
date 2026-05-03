//
//  ServerFile+default.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/27/26.
//


import Vapor
import TSShared
import NIOCore

public extension ServerFileUploadable {
    
    //Default is set to post , you can override it by defining a value in your concrete type
    static var method: HttpMethod { .POST }
    
    static var transferMethod: FileTransferMethod { .collect(.mb(25)) }
    
}
