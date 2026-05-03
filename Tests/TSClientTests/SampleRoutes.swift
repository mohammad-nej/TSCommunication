//
//  SampleRoutes.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/1/26.
//



import TSShared
import Foundation
import TSClient




struct UploadBigFileTest : ClientLargeFileUploadable {
    typealias OutputData = Bool
    static var path: TSShared.ServerPath { "uploadBigFile"}
}

struct FileDownloadableTest : ClientFileDownloadable {
    typealias OutputData = Data
    static var path: TSShared.ServerPath { "downloadFile" }
}


struct UploadSmallFileTest : ClientSmallFileUploadable {
    typealias InputData = String
    typealias OutputData = Bool
    static var path: TSShared.ServerPath { "uploadSmallFile" }
}

struct GeneralRouteTest : ClientHttpRoute {
    typealias InputData = String
    typealias OutputData = Bool
    static var path: TSShared.ServerPath { "testGeneral"}
    static var method: TSShared.HttpMethod { .POST }
}


struct WebSocketTest : ClientWebSocketRoute {
    static var path: TSShared.ServerPath { "webSocket"}
}

