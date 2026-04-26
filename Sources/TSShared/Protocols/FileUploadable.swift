//
//  FileUploadable.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/24/26.
//

import Foundation


///Indicate a route that is used for uploading a file to server
public protocol FileUploadable : HttpRoute {}

public extension FileUploadable {
    static var method : HttpMethod { .post }
}
