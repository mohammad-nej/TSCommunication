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
    
    ///Creates a multipart  request and injects your  data and metaData in the test request
    ///
    ///```swift
    /////on your beforeRequest closure in route testing
    ///try await app.testing().test(MyUploadableRoute){ request in
    ///  try MyUploadableRoute.modifyRequest(metaData:"Extra info",filename:"myfile.txt", data:fileData,using: &request)
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
            let dtoData = try encoder.encode(metaData)
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
