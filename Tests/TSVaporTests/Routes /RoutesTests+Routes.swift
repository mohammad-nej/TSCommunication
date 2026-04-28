//
//  RoutesTests+Routes.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import Foundation
import TSVapor
import TSShared
import Vapor

extension UUID: @retroactive RequestDecodable {}
extension UUID: @retroactive ResponseEncodable {}
extension UUID: @retroactive AsyncRequestDecodable {}
extension UUID: @retroactive AsyncResponseEncodable {}
extension UUID : @retroactive Content {}

extension RoutesTests {
    ///Greeting Route
    struct EchoRoute : ServerRouteProtocol {
                
        static var closure: @Sendable (Vapor.Request) async throws -> String {
            return { req in
                let value = try EchoRoute.decodeInput(in: req)
                return "echo: \(value)"
            }
        }
        
        static let path: TSShared.ServerPath = "greet"
        
        static let method: TSShared.HttpMethod = .post
        
        typealias InputData = String
        typealias OutputData = String
        
    }
    
    ///Get Id route
    struct GetId : ServerGetRouteProtocol {
        
        
        static var closure: @Sendable (Vapor.Request) async throws -> UUID {
            return { req in
                guard let id =  req.parameters.get("id",as: UUID.self) else {
                    throw Abort(.notFound)
                }
                return id
            }
        }
        
        static let path: TSShared.ServerPath = "getId/:id"
        
        typealias OutputData = UUID
        
    }
    
    ///Route for downloading a file from server
    struct DownloadFile : ServerFileDownloadable{
        typealias InputData = NoData
    
        static var closure: @Sendable (Vapor.Request) async throws -> Vapor.Response{
            return { req in
                guard let text = req.parameters.get("text", as: String.self) else {
                    throw Abort(.badRequest)
                }
                
                
                
                
                
                let data = text.data(using: .utf8)!
                
                let url = req.application.directory.workingDirectory.appending("test.txt")
                try await req.fileio.writeFile(ByteBuffer(data: data), at: url)
               
                guard let url = URL(string: url) else { throw URLError(.badURL)}
                
                return try await DownloadFile.send(file: url, request: req)
            }
        }
        
        static let path: TSShared.ServerPath = "download/:text"
        
    }
    struct UploadFile : ServerFileUploadable{
        
        typealias InputData = String
        
        static var closure: @Sendable (Vapor.Request) async throws -> Bool{
            return { req in
                let (file, metadata) = try UploadFile.getFileAndInputData(from: req)
                
                return true
            }
        }
        
        typealias OutputData = Bool
        
        static let path: TSShared.ServerPath = "uploadFile"
        
        static let method: TSShared.HttpMethod = .delete
        
    }
}
