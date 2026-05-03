//
//  FileUploadable.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/24/26.
//

import Foundation


/// a route that is used for uploading a file to server
public protocol FileUploadable : InputOutputableRoute{
    
}

public extension FileUploadable {
    static var method : HttpMethod { .POST }
}
