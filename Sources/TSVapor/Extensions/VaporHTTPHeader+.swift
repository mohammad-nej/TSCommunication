//
//  VaporRequest+.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/8/26.
//

import Foundation
import TSShared
import Vapor


///Lets you fetch/insert common HTTP headers by subscript
public extension Vapor.HTTPHeaders {
//Because Vapor already defined almost all headers as HTTPHeader.Name
//creating this subscript will pollute the namespace and creates ambiguity for compiler
//    subscript (_ header: CommonHeader) -> [String] {
//        get{
//            return self[header.name]
//        }
//        set {
//            newValue.forEach { self.add(name: header.name, value: $0) }
//        }
//    }
    
    func get(_ header : CommonHeader) -> [String] {
        self[header.name]
    }
    
    ///Adds an http header
    mutating func append(_ header : CommonHeaderItem) {
        self.add(name: header.name, value: header.value)
    }
}

