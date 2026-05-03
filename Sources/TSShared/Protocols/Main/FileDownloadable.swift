//
//  FileDownloadable.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/24/26.
//

import Foundation

///a route that is used for downloading data from server
public protocol FileDownloadable : OutputableRoute where OutputData == Data { }

public extension FileDownloadable {
    static var method: HttpMethod { .GET }
}
