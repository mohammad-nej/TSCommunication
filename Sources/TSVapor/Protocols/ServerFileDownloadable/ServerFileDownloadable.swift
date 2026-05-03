//
//  DownloadableServerRouteProtocol.swift
//  Whisper
//
//  Created by MohammavDev on 4/9/26.
//

import TSShared
import Vapor

///Used for routes that let clients download a large file into their devices
public protocol ServerFileDownloadable :  FileDownloadable,AnyHttpRoute, FileTransferMethodable where OutputData == Data, ClosureResponse == Response{
    
}

extension ServerFileDownloadable{
    public static var method: HttpMethod{ .GET }

    ///Streams a file to the client
    public static func send(file path : URL, request : Request) async throws -> Response{
        let response = try await request.fileio.asyncStreamFile(at: path.path())
        response.headers.add(name: .contentType, value: "application/octet-stream")
        return response
    }
}
