//
//  Sample Routes.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//

import TSVapor
import TSShared
import Foundation
import Vapor



struct SecondTest : ServerFileUploadable {
   static var closure: @Sendable (Vapor.Request) async throws -> Bool {
       return { request in
           return true
       }
   }
   
   typealias InputData = String
   
   typealias OutputData = Bool
   
   static let path: ServerPath = "testPath2"
   
   static let method: TSShared.HttpMethod = .POST
   
}


struct ThirdTest : ServerGetRouteProtocol {
  static var closure: @Sendable (Vapor.Request) async throws -> Bool {
      return { request in
          return true
      }
  }
  
  typealias OutputData = Bool
  
  static let path: ServerPath = "testPath3"
}

struct ThirdTestSimillar : ServerGetRouteProtocol {
   static var closure: @Sendable (Vapor.Request) async throws -> Bool {
       return { request in
           return true
       }
   }
   
   typealias OutputData = Bool
   
   static let path: ServerPath = "testPath3"

}

struct BehindBothMiddlewares : ServerFileUploadable {
   static var closure: @Sendable (Vapor.Request) async throws -> Bool {
       return { request in
           let values = request.headers["Test-Header"]
           
           guard values.count == 2 else { throw Abort(.badRequest)}
           
           
           
           guard values[0] == "Middle ware 2 is working" else {
               return false
           }
           
           guard values[1] == "Middle ware 1 is working" else {
               return false
           }
           
           return true
       }
   }
   
   typealias InputData = String
   
   typealias OutputData = Bool
   
   static let path: ServerPath = "testPath"
   
   static let method: TSShared.HttpMethod = .POST
   
}
// MARK: Middlewares
struct TestMiddleWare2 : AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        request.headers.add(name: "Test-Header", value: "Middle ware 2 is working")
        return try await next.respond(to: request)
    }
}

struct TestMiddleWare : AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        
        request.headers.add(name: "Test-Header", value: "Middle ware 1 is working")
        return try await next.respond(to: request)
    }
}
