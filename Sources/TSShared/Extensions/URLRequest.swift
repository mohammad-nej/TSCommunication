//
//  URLRequest.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/8/26.
//

import Foundation



public extension URLRequest {
    
    ///Adds a ``CommonHeader`` to this request
    mutating func appending(_ header : CommonHeaderItem) {
        self.addValue(header.value, forHTTPHeaderField: header.name)
    }
    
    ///Creates a new `URLRequest` by adding a header to this request
    func append(_ header : CommonHeaderItem) -> URLRequest {
        var newValue = self
        newValue.appending(header)
        return newValue
    }
    
     subscript (_ header : CommonHeader) -> String?{
         get{
             self.value(forHTTPHeaderField: header.name)
         }
         set{
             if let newValue{
                 self.addValue(newValue, forHTTPHeaderField: header.name)
             }
         }
    }
}
