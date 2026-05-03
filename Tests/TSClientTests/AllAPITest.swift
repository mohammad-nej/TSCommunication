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
    
    static let method: TSShared.HttpMethod = .GET
    
}

struct FileUploadePath : ClientSmallFileUploadable {
    
    typealias InputData = String
    
    typealias OutputData = Bool
    
    static let path: TSShared.ServerPath = "upload"
    
}

struct HeavyFileUploadePath : ClientLargeFileUploadable {
    
    typealias OutputData = Bool
    
    static let path: TSShared.ServerPath = "upload"
    
}


@Suite("API of all routes")
struct RequestSender {
    
    
    @Test("testing all APIs")
    func downloadFile() async throws {
        
        let error = VaporError(error: true, reason: "error from server")
        
        let downloadResponse = try await FileDownloadableTest.download(
            parameters: [],
            config: FileDownloadableTest.mockConfig(
                always: "Test".data(
                    using: .utf8
                )!
            )
        )
        let download = try downloadResponse.asOutput
        let downloadEnum = try downloadResponse.asResult
        let downloadErrorResponse = try await FileDownloadableTest.download(
            parameters: [],
            config: FileDownloadableTest.mockConfig(throws: error))
        let downloadEnumError = try downloadErrorResponse.asResult
        let downloadError = try downloadErrorResponse.asServerError
        
        #expect(downloadEnum == .success("Test".data(using: .utf8)!))
        #expect(download == "Test".data(using: .utf8)!)
        #expect(downloadError == error)
        #expect(downloadEnumError == .failure(error))
        
        let uploadData = try await UploadSmallFileTest.upload(
            metaData: "test",
            data: "test".data(using: .utf8)!,
            filename: "test.txt",
            config: UploadSmallFileTest.mockConfig(always: true)
        ).asOutput
        let uploadError = try await UploadSmallFileTest.upload(
            metaData: "test",
            data: "test".data(using: .utf8)!,
            filename: "test.txt",
            config: UploadSmallFileTest.mockConfig(throws: error)
        ).asServerError
        #expect(uploadData)
        #expect(uploadError == error)
        
        
        let bigUpload = try await UploadBigFileTest.upload(
            fileUrl: .mock,
            config: UploadBigFileTest.mockConfig(always: true))
            .asOutput
        let bigUploadError = try await UploadBigFileTest.upload(
            fileUrl: .mock,
            config: UploadBigFileTest.mockConfig(throws: error)
        ).asServerError
        #expect(bigUpload)
        #expect(bigUploadError == error)
        
        let get = try await SampleGetRoute.get(
            parameters: [],
            config: SampleGetRoute.mockConfig(
                always: true
            )
        ).asOutput
        let getError = try await SampleGetRoute.get(
            parameters: [],
            config: SampleGetRoute.mockConfig(throws: error)
        ).asServerError
        #expect(get)
        #expect(getError == error)
        
        let general = try await GeneralRouteTest
            .send("test", config: GeneralRouteTest.mockConfig(always: true))
            .asOutput
        let generalError = try await GeneralRouteTest
            .send("test", config: GeneralRouteTest.mockConfig(throws: error))
            .asServerError
        
        #expect(generalError == error)
        #expect(general)
    }
}
