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
struct RoutesTests{
        
    let prepare : AppPreparationClosure = { _ in }

    @Test("A get request from out server")
    func getRequest() async throws {
        
        let tester = ServerTest(){ app in
            
            RouteInserter(to: app) {
                GetId.self
            }
        }
        
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
    
    @Test("HTML route tests")
    func htmlRoutes() async throws {
        try await SampleGetHTMLRoute.test(prepare:SampleGetHTMLRoute.insertToApp){ req in
            
        }afterResponse: { response in
            let output = try SampleGetHTMLRoute.output(from: response)
            #expect(output == .sample("<p>Hello from get route</p>"))
        }
        
        try await SamplePostHTMLRoute.test(prepare: SamplePostHTMLRoute.insertToApp){ req in
            try SamplePostHTMLRoute.insert("Sample value", in: &req)
        }afterResponse: { response in
            let output = try SamplePostHTMLRoute.output(from: response)
            #expect(output == .sample("Sample value"))
        }
    }
    
    @Test("A post request to send data to server")
    func postRequest() async throws {
      
        try await EchoRoute.test(prepare:EchoRoute.insertToApp){ req  in
            try EchoRoute.insert("This is a test", in: &req)
            
        }afterResponse: { response in
            try #require(response.status == .ok)
            
            let serverAnswer = try EchoRoute.output(from: response)
            #expect(serverAnswer == "echo: This is a test")

        }
       
        
    }
    
    @Test("Test downloading a file to server")
    func downloadFile() async throws {
        
        
        let fileText = "This is a test file"
        
        try await DownloadFile.test(parameters: [fileText],prepare: DownloadFile.insertToApp){req in
            
        }afterResponse: { response in
            try #require(response.status == .ok)
            
            let file = DownloadFile.output(from: response)
            
            let value = String(data:file,encoding: .utf8)
            #expect(value == fileText)
        }
        
        await #expect(throws: URLConversionError.insufficientAmountOfParameters){
            try await DownloadFile.test( parameters: []){req in
            }afterResponse: { response in
                try #require(response.status == .ok)
                
                let file = DownloadFile.output(from: response)
                
                let value = String(data:file,encoding: .utf8)
                #expect(value == fileText)
            }
        }
        
        await #expect(throws: URLConversionError.extraAmountOfParameters){
            try await DownloadFile.test( parameters: [fileText,"someother"]){req in
            }afterResponse: { response in
                try #require(response.status == .ok)
                
                let file = DownloadFile.output(from: response)
                
                let value = String(data:file,encoding: .utf8)
                #expect(value == fileText)
            }
        }
        
    }
    
    @Test("Test uploading a file to server")
    func uploadFile() async throws {
        
        try await UploadFile.test(prepare:UploadFile.insertToApp){req in
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
