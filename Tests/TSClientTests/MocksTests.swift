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


extension URL{
    static let mock = URL(string: "https://fake.url")!
}

extension URLRequest{
    static let mock = URLRequest(url: .mock)
}

@Suite("Testing mocks ")
struct MocksTests {
    
    
//    @Test("A constant responder")
//    func constantResponder() async throws {
//        let responder = MockResponder(always: "Hello I am running")
//        
//        let (response1, _) = try await responder.upload(for: .mock, from: Data(), delegate: nil)
//        let (response2, _) = try await responder.data(for: .mock, delegate: nil)
//        let (response3, _) = try await responder.upload(for: .mock, fromFile: .mock, delegate: nil)
//        
//        let decoded1 = try JSONDecoder().decode(String.self, from: response1)
//        let decoded2 = try JSONDecoder().decode(String.self, from: response2)
//        let decoded3 = try JSONDecoder().decode(String.self, from: response3)
//        
//        #expect(decoded1 == "Hello I am running")
//        #expect(decoded2 == "Hello I am running")
//        #expect(decoded3 == "Hello I am running")
//        
//        
//        let responder2 = MockResponder {
//            let value = "Hello I am running" + " 2"
//            
//            return (value,URLResponse())
//        }
//        
//        let (response21, _) = try await responder2.upload(for: .mock, from: Data(), delegate: nil)
//        let (response22, _) = try await responder2.data(for: .mock, delegate: nil)
//        let (response23, _) = try await responder2.upload(for: .mock, fromFile: .mock, delegate: nil)
//        
//        let decoded21 = try JSONDecoder().decode(String.self, from: response21)
//        let decoded22 = try JSONDecoder().decode(String.self, from: response22)
//        let decoded23 = try JSONDecoder().decode(String.self, from: response23)
//        
//        #expect(decoded21 == "Hello I am running 2")
//        #expect(decoded22 == "Hello I am running 2")
//        #expect(decoded23 == "Hello I am running 2")
//        
//    }
    
    @Test("Get server mock")
    func getClientResponder() async throws {
        
        let serverMock = MockGetServer(for: SampleGetRoute.self, always: true)
        
        let config = serverMock.config
        let result = try await SampleGetRoute.get(parameters: [], config: config).asOutput
        #expect(result)
        
        let returnValue = false
        let logicalMock = MockGetServer(for: SampleGetRoute.self) { request in
            return (returnValue,URLResponse())
        }
        let config2 = logicalMock.config
        let result2 = try await SampleGetRoute.get(parameters: [], queryItems: [], config: config2).asOutput
        #expect(!result2)
        
    }
    
    @Test("Upload server mock")
    func uploadServerMock() async throws {
        let serverMock = MockUpServer(for: FileUploadePath.self) { data, request in
           
            let hello = "hello".data(using: .utf8)!
            let result = data.contains(hello)
            return (result,URLResponse())
        }
        let config = serverMock.config
        
        
        let value = try await FileUploadePath.upload(metaData: "this is meta data",
                                         data: "test data".data(using: .utf8)!,
                                                     filename: "file.txt", config: config).asOutput
        
        #expect(!value)
        
        let value2 = try await FileUploadePath.upload(metaData: "hello",
                                         data: "test data".data(using: .utf8)!,
                                                      filename: "file.txt", config: config).asOutput
        
        #expect(value2)
  
        let value3 = try await HeavyFileUploadePath.upload(fileUrl: .mock,
                                                               parameters: [],
                                                               queryItems: [],
                                                           config: HeavyFileUploadePath.mockConfig(always: true)).asOutput
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
