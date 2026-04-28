//
//  UploadingFileToServer.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/25/26.
//


import Testing
import TSShared
import TSClient
import Foundation







struct SampleGetRoute : ClientGetRouteProtocol {
   
   
    
    typealias OutputData = Bool
    
    static let path: TSShared.ServerPath = "something"
    
    static let method: TSShared.HttpMethod = .get
    
}

struct FileUploadePath : ClientSmallFileUploadable {
   
    typealias InputData = String
    
    typealias OutputData = Bool
    
    static let path: TSShared.ServerPath = "upload"
    
}

struct HeavyFileUploadePath : ClientBigFileUploadable {
    
    
    
 
    typealias OutputData = Bool
    
    static let path: TSShared.ServerPath = "upload"
    
}


@Suite("Sending requets to server")
struct RequestSender {
    
   
    
    @Test("Get request from server")
    func sendRequests() async throws {
        
        let result = try await SampleGetRoute.get(parameters: [],config: SampleGetRoute.mockConfig(always: true)).asOutput
        #expect(result)
        
        #expect(FileUploadePath.method == .post)
        let uploadResult = try await FileUploadePath.upload(metaData: "this is test",
                                                                 data: "test".data(using: .utf8)!,
                                                                 filename: "test.txt",
                                                            config: FileUploadePath.mockConfig(always: true)).asOutput
        #expect(uploadResult)
        
//        let url = URL(string: "/path/to/file.txt")!
        let bigUploadable = try await HeavyFileUploadePath.upload(fileUrl: .mock, config:HeavyFileUploadePath.mockConfig(always: true)).asOutput
        #expect(bigUploadable)
    }
    
}
