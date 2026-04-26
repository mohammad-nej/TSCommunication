//
//  FileDownloadable.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/24/26.
//

import Foundation

///Indicates a route that is used for downloading data from server
public protocol FileDownloadable : GetHttpRoute { }

public extension FileDownloadable {
    static var method: HttpMethod { .get }
}
