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


enum SampleGetRoute : ClientGetRouteProtocol {
    
    
    
    typealias OutputData = Bool
    
    static let path: TSShared.ServerPath = "something"
    
    static let method: TSShared.HttpMethod = .GET
    
}

enum FileUploadePath : ClientSmallFileUploadable {
    
    typealias InputData = String
    
    typealias OutputData = Bool
    
    static let path: TSShared.ServerPath = "upload"
    
}

enum HeavyFileUploadePath : ClientLargeFileUploadable {
    
    typealias OutputData = Bool
    
    static let path: TSShared.ServerPath = "upload"
    
}


@Suite("API of all routes")
struct RequestSender {
    
    
    @Test("testing all APIs")
    func downloadFile() async throws {
        
        let error = VaporError(error: true, reason: "error from server")
        let fileData = "Test".data(using: .utf8)!
        let downloadResponse = try await FileDownloadableTest.download(
            parameters: [],
            server:.test,
            client: FileDownloadableTest.mockClient(always: fileData))
        
        let download = try downloadResponse.asOutput
        let downloadEnum = try downloadResponse.asResult
        let downloadErrorResponse = try await FileDownloadableTest.download(
            parameters: [],
            server:.test,
            client: FileDownloadableTest.mockClient(throws: error))
        let downloadEnumError = try downloadErrorResponse.asResult
        let downloadError = try downloadErrorResponse.asServerError
        
        #expect(downloadEnum == .success(fileData))
        #expect(download == fileData)
        #expect(downloadError == error)
        #expect(downloadEnumError == .failure(error))
        
        let uploadData = try await UploadSmallFileTest.upload(
            metaData: "test",
            data: "test".data(using: .utf8)!,
            filename: "test.txt",
            server: .test,
            client: UploadSmallFileTest.mockClient(always: true)
        ).asOutput
        let uploadError = try await UploadSmallFileTest.upload(
            metaData: "test",
            data: "test".data(using: .utf8)!,
            filename: "test.txt",
            server:.test,
            client: UploadSmallFileTest.mockClient(throws: error)
        ).asServerError
        #expect(uploadData)
        #expect(uploadError == error)
        
        let server = MockFileServer(for: UploadBigFileTest.self, always: true)
        let bigUpload = try await UploadBigFileTest.upload(
            fileUrl: .mock,
            server: .test,
            client:server)
            .asOutput
        
        
        let bigUploadError = try await UploadBigFileTest.upload(
            fileUrl: .mock,
            server: .test, client: UploadBigFileTest.mockClient(throws: error)
        ).asServerError
        #expect(bigUpload)
        #expect(bigUploadError == error)
        
        let get = try await SampleGetRoute.get(
            parameters: [],
            server:.test,
            client: SampleGetRoute.mockClient(
                always: true
            )
        ).asOutput
        let getError = try await SampleGetRoute.get(
            parameters: [],
            server: .test,
            client: SampleGetRoute.mockClient(throws: error)
        ).asServerError
        #expect(get)
        #expect(getError == error)
        
        let general = try await GeneralRouteTest
            .send("test", server:.test ,client: GeneralRouteTest.mockClient(always: true))
            .asOutput
        let generalError = try await GeneralRouteTest
            .send("test", server: .test ,client: GeneralRouteTest.mockClient(throws: error))
            .asServerError
        
        #expect(generalError == error)
        #expect(general)
    }
}
