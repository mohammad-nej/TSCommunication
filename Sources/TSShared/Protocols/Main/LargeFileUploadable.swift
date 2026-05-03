//
//  LargeFileUploadable.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/2/26.
//

///Protocol for routes that client will upload a large file to server
public protocol LargeFileUploadable : OutputableRoute {}

public extension LargeFileUploadable {
    static var method: HttpMethod { .POST }
}
