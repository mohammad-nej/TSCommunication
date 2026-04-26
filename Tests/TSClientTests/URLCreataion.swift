//
//  URLCreataion.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import Foundation
import Testing
import TSShared
@testable import TSClient

@Suite("URL related tests")
struct URLCreationTests {
    
    
    
    
    @Test("Create url")
    func craeteURLTest() throws {
        let id = UUID().uuidString
        
        let queryItems = ["name" : "something"]
        let path : ServerPath = "users/:id/posts"
        let url = try path.createURL(parameters: [id], queryItems: queryItems , server: .local, mode: .safe)
        
        let expected = ServerConfiguration.local.url!
            .appending(path: "users")
            .appending(path: id)
            .appending(path: "posts")
            .appending(queryItems: queryItems.toQueryItem)
        
        #expect(url == expected)
        
        #expect(throws: URLConversionError.insufficientAmountOfParameters) {
            try path.createURL(parameters: [], queryItems: queryItems, server: .local, mode: .safe)
        }
        
        #expect(throws: URLConversionError.extraAmountOfParameters){
            try path.createURL(parameters: [id , "myname"], queryItems: queryItems, server: .local, mode: .safe)
        }
        
        let expected2 = ServerConfiguration.local.url!
            .appending(path: "users")
            .appending(path: id)
            .appending(path: "posts")
            .appending(path: "something")
            .appending(path: "someother")
        
        let path2 : ServerPath = "users/:id/posts/*/**"
        
        let url2 = try path2.createURL(parameters: [id,"something","someother"], server: .local, mode: .safe)
        
        #expect(url2 == expected2)
        
        #expect(throws: URLConversionError.insufficientAmountOfParameters) {
            try path2.createURL(parameters: [id], server: .local, mode: .safe)
        }
        
        let expected3 = expected2
            .appending(path: "some more things")
            
        let url3 = try path2.createURL(parameters: [id,"something","someother", "some more things"], server: .local, mode: .safe)
        #expect(url3 == expected3)
    }
    
}
