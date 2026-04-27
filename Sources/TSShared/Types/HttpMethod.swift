//
//  HttpMethod.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

///Common Http methods
public enum HttpMethod : String , Codable , Sendable , Equatable , Hashable{
    case get = "GET" , post = "POST" , put = "PUT" , delete = "DELETE" , patch = "PATCH"
}
