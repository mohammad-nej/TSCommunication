//
//  Untitled.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/24/26.
//

@testable import TSVaporTestSupport
import Testing
import TSVapor
import TSShared
import Vapor
import VaporTesting
@Suite("General tests")
struct GeneralTests {
    
    struct UploadFile : ServerFileUploadable{
        
        typealias InputData = String
        
        static var closure: @Sendable (Vapor.Request) async throws -> Bool{
            return { req in
                
                return true
            }
        }
        
        typealias OutputData = Bool
        
        static let path: TSShared.ServerPath = "uploadFile"
        
        static let method: TSShared.HttpMethod = .delete
        
        static var contentType: ContentType { .jpeg}
    }
    
    
    
    @Test("Test modifing the request for uploadable routes")
    func testModifiing() throws{
        
        
        var request = TestingHTTPRequest(method: .POST, url: .init(scheme: "http", path: "localhost.com"), headers: .init(), body: .init())
        
        let dataString = "this is sample data"
        let data = dataString.data(using: .utf8)!
        
        let filename = try FileName(name: "myfile.txt")
        
        try UploadFile.modifyRequest(metaData: "something", filename: filename, data: data, using: &request)
        
        let body = Data(buffer: request.body)
        
        let lines = String(data:body,encoding:.utf8)!.split(separator: "\r\n", omittingEmptySubsequences: false)
        
        #expect(lines.count == 12)
        
        let boundryText = String(lines[0].dropFirst(2))
        _ = try #require(UUID(uuidString:boundryText))
        
        
        #expect(lines[1] == "Content-Disposition: form-data; name=\"metaData\"")
        #expect(lines[2] == "Content-Type: application/json")
        #expect(lines[3] == "")
        #expect(lines[4] == "\"something\"")
        #expect(lines[5] == "--\(boundryText)")
        #expect(lines[6] == "Content-Disposition: form-data; name=\"file\"; filename=\"\(filename.fullname)\"")
        #expect(lines[7] == "Content-Type: \(UploadFile.contentType.rawValue)")
        #expect(lines[8] == "")
        #expect(lines[9] == dataString)
        #expect(lines[10] == "--\(boundryText)--")
        #expect(lines[11] == "")
        
        let typeHeader = try #require(request.headers["Content-Type"].first)
        #expect(typeHeader == "multipart/form-data; boundary=\(boundryText)" )
    }
    
    
}
