//
//  URLResponse.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/8/26.
//

import Foundation

public extension URLResponse {
    subscript (_ header: CommonHeader) -> String? {
        
            if let response = self as? HTTPURLResponse {
                return response.value(forHTTPHeaderField: header.name)
                
            }
            return nil
        
    }
    
    ///Returns value for provided header, otherwise nil
    func header(_ header : CommonHeader) -> String? {
        self[header]
    }
}
