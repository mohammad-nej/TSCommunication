//
//  UploadableRoute+.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import Foundation
import TSVapor
import TSShared
import VaporTestUtils
import Vapor

public extension ServerFileUploadable {
    
    ///Creates a multipart request and injects your  data and metaData in the request
    ///
    ///This functions uses the following format
    ///```swift
    ///{
    /// metaData : String,
    /// file : Vapor.File
    ///}
    ///```
    ///which matches the definition of `_MetaData` type (provided in this package)
    ///to send your request to server.
    ///
    ///On your route in server static function`getFileAndInputData(from:(inout) TestingHTTPRequest,using:JSONDecoder)` can be used
    ///on your route-type to get your file and metaData from your request
    ///```swift
    /////on your beforeRequest closure in route testing
    ///try await app.testing().test(MyUploadableRoute){ request in
    /// let (file,metaData) = try MyUploadableRoute.getFileAndInput(from: request)
    /// //....
    ///}
    ///```
     static func modifyRequest(
        metaData : Self.InputData,
        filename : FileName,
        data : Data,
        encoder : JSONEncoder = JSONEncoder(),
        using request : inout TestingHTTPRequest) throws{
            
            let boundary = UUID().uuidString
            let dtoData = try encoder.encodeIfNeeded(metaData)
            request.headers.add(name: "Content-Type", value: "multipart/form-data; boundary=\(boundary)")
            
            var body = Data()
            //dto
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"metaData\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/json\r\n".data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
            body.append(dtoData)
            body.append("\r\n".data(using: .utf8)!)
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename.fullname)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(Self.contentType.rawValue)\r\n".data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
            body.append(data)
            body.append("\r\n".data(using: .utf8)!)
            
            //end of body
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.body = ByteBuffer(data:body)
            
    }
    
}
