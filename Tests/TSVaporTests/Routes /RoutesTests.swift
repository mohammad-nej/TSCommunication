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
    
    
    var  routes : [any AnyBuildable] { [GetId(), EchoRoute(), DownloadFile() , UploadFile()] }
    
    let prepare : AppPreparationClosure = { _ in }
    
    
    
    @Test("result builder")
    func resultBuilder() async throws{
        let tester = ServerTest()
        try await tester.withApp{ app in
            
            
            let all = try RouteInserter(to: app) {
                With(middlewares: [TestMiddleWare(),TestMiddleWare2()]) {
                    GetId()
                    With(middlewares: [TestMiddleWare2()]) {
                        UploadFile()
                    }
                    
                }
                
               
                DownloadFile()
            }
            
            #expect(all.registrar.builders.count == 1)
            let inners = all.registrar.builders.first!.innerBuilder
            #expect(inners[0].middleWares.count == 2)
            #expect(inners[1].middleWares.count == 0)
            
            let firstLayer = inners[0]
            
            #expect(firstLayer.innerGroup.count == 1)
            #expect(firstLayer.routes.count == 1)
            #expect(firstLayer.routes.first!.self is GetId.Type)
            
            let secondLayer = firstLayer.innerGroup.first!
            #expect(secondLayer.middleWares.count == 1)
            #expect(secondLayer.routes.count == 1)
            #expect(secondLayer.routes.first!.self is UploadFile.Type)
            
        }
    }
    
 
    
    @Test("A get request from out server")
    func getRequest() async throws {
        let builders = routes.map { $0.innerMiddleware
        }
        let tester = ServerTest(){ app in
           try RouteInserter(to: app) {
                With(middlewares: []) {

                    for route in builders {
                        route
                    }

                }
               for route in builders {
                   route
               }
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
            
            let file = try DownloadFile.output(from: response)
            
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
