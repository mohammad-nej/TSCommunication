//
//  SampleRoutes.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/1/26.
//



import TSShared
import Foundation
import TSClient




enum UploadBigFileTest : ClientLargeFileUploadable {
    typealias OutputData = Bool
    static var path: TSShared.ServerPath { "uploadBigFile"}
}

enum FileDownloadableTest : ClientFileDownloadable {
    typealias OutputData = Data
    static var path: TSShared.ServerPath { "downloadFile" }
}


enum UploadSmallFileTest : ClientSmallFileUploadable {
    typealias InputData = String
    typealias OutputData = Bool
    static var path: TSShared.ServerPath { "uploadSmallFile" }
}

enum GeneralRouteTest : ClientHttpRoute {
    typealias InputData = String
    typealias OutputData = Bool
    static var path: TSShared.ServerPath { "testGeneral"}
    static var method: TSShared.HttpMethod { .POST }
}


enum WebSocketTest : ClientWebSocketRoute {
    static var path: TSShared.ServerPath { "webSocket"}
}

