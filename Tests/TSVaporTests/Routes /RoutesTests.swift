//
//  RoutesTests.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import Foundation
import Testing
import TSShared
@testable import TSVapor
import TSVaporTestSupport
import Vapor



@Suite("Testing different routes to a server")
struct RoutesTests {
    
    let routes : [any AddableRoute] = [GetId(), EchoRoute(), DownloadFile() , UploadFile()]
    
    
    
    @Test("A get request from out server")
    func getRequest() async throws {
        
        let tester = ServerTest(routes: routes)
    
        try await tester.withApp{ app in
            let id = UUID()
            try await app.testing().test(GetId.self, parameters: [id.uuidString]){ req in
                
            }afterResponse: { response in
                try #require(response.status == .ok)
                
                let newId = try GetId.output(from: response)
                #expect(newId == id)
            }
        }
    }
    
    @Test("A post request to send data to server")
    func postRequest() async throws {
        let tester = ServerTest(routes: routes)
    
        try await tester.withApp{ app in
            
            try await app.testing().test(EchoRoute.self){ req in
                try EchoRoute.insert("This is a test", in: &req)
                
            }afterResponse: { response in
                try #require(response.status == .ok)
                
                let serverAnswer = try EchoRoute.output(from: response)
                #expect(serverAnswer == "echo: This is a test")
            }
        }
    }
    
    @Test("Test downloading a file to server")
    func downloadFile() async throws {
        let tester = ServerTest(routes: routes)
        
        let fileText = "This is a test file"
        try await tester.withApp { app in
            try await app.testing().test(DownloadFile.self, parameters: [fileText]){req in
                
            }afterResponse: { response in
                try #require(response.status == .ok)
                
                let file = DownloadFile.output(from: response)
                
                let value = String(data:file,encoding: .utf8)
                #expect(value == fileText)
            }
            
            await #expect(throws: URLConversionError.insufficientAmountOfParameters){
                try await app.testing().test(DownloadFile.self, parameters: []){req in
                }afterResponse: { response in
                    try #require(response.status == .ok)
                    
                    let file = DownloadFile.output(from: response)
                    
                    let value = String(data:file,encoding: .utf8)
                    #expect(value == fileText)
                }
            }
            
            await #expect(throws: URLConversionError.extraAmountOfParameters){
                try await app.testing().test(DownloadFile.self, parameters: [fileText,"someother"]){req in
                }afterResponse: { response in
                    try #require(response.status == .ok)
                    
                    let file = DownloadFile.output(from: response)
                    
                    let value = String(data:file,encoding: .utf8)
                    #expect(value == fileText)
                }
            }

        }
    }
    
    @Test("Test uploading a file to server")
    func uploadFile() async throws {
        let tester = ServerTest(routes: routes)
 
        try await tester.withApp { app in
            try await app.testing().test(UploadFile.self){req in
                let fileData = "This is test".data(using: .utf8)!
                try UploadFile.modifyRequest(metaData: "This is a test meta data", filename: "myfile.txt", data: fileData, using: &req)
                
                #expect(req.method == .DELETE)
            }afterResponse: { response in
                try #require(response.status == .ok)
                
                let answer = try UploadFile.output(from: response)
                
                
                #expect(answer)
            }
        }
    }

}
