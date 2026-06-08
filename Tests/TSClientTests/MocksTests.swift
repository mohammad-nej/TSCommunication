//
//  MocksTests.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import Foundation
import Testing
import TSShared
import TSClient
#if os(Linux)
import FoundationNetworking
#endif

extension URL{
    static let mock = URL(string: "https://fake.url")!
}

extension URLRequest{
    static let mock = URLRequest(url: .mock)
}

@Suite("Testing mocks ")
struct MocksTests {

    @Test("Get server mock")
    func getClientResponder() async throws {
        
        let serverMock = MockGetServer { request in
            if let value = request.value(forHTTPHeaderField: "Test header"), value == "hello"{
                return (true,URLResponse())
            }
            return (false,URLResponse())
        }
        
//        let config = serverMock.config
        let result = try await SampleGetRoute.get(parameters: [],server: .test,client:serverMock){ request in
            request.setValue("hello", forHTTPHeaderField: "Test header")
        }
        .asOutput
        #expect(result)
        
        let returnValue = false
        let logicalMock = MockGetServer(for: SampleGetRoute.self) { request in
            return (returnValue,URLResponse())
        }
        
        let result2 = try await SampleGetRoute.get(parameters: [], queryItems: [],server: .test,client:logicalMock).asOutput
        #expect(!result2)
        
    }
    
    @Test("Upload server mock")
    func uploadServerMock() async throws {
        let serverMock = MockUpServer(for: FileUploadePath.self) { data, request in
           
            let hello = "hello".data(using: .utf8)!
            let result = data.contains(hello)
            return (result,URLResponse())
        }
        
        
        
        let value = try await FileUploadePath.upload(metaData: "this is meta data",
                                         data: "test data".data(using: .utf8)!,
                                                     filename: "file.txt", server: .test,client: serverMock).asOutput
        
        #expect(!value)
        
        let value2 = try await FileUploadePath.upload(metaData: "hello",
                                         data: "test data".data(using: .utf8)!,
                                                      filename: "file.txt", server: .test,client: serverMock).asOutput
        
        #expect(value2)
        let server = MockFileServer(for: HeavyFileUploadePath.self, always: true)
        let value3 = try await HeavyFileUploadePath.upload(fileUrl: .mock,
                                                               parameters: [],
                                                           queryItems: [],
                                                           server: .test,
                                                           client: server).asOutput
        #expect(value3)
        
        
    }
    
    @Test("General server mock")
    func generalMock() async throws {
        let server = MockHttpServer { data, request in
            let ok = try JSONEncoder().encode(true)
            return (ok,URLResponse())
        } downloadData: { request in
            let fileData = try JSONEncoder().encode("This is my file")
            return (fileData,URLResponse())
        } uploadFile: { ur, request in
            let ok = try JSONEncoder().encode(true)
            return (ok,URLResponse())
        }

        let (result , _ ) = try await server.data(for: .mock, delegate: nil)
        let (result2 , _ ) = try await server.upload(for: .mock, from: "this mockData".data(using: .utf8)!, delegate: nil)
        let (result3 , _ ) = try await server.upload(for: .mock, fromFile: .mock, delegate: nil)
        
        let decoder = JSONDecoder()
        
        let decoded1 = try decoder.decode(String.self, from: result)
        let decoded2 = try decoder.decode(Bool.self, from: result2)
        let decoded3 = try decoder.decode(Bool.self, from: result3)
        
        #expect(decoded1 == "This is my file")
        #expect(decoded2)
        #expect(decoded3)
   
    }
}
