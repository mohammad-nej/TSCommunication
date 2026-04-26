//
//  Dictionary+.swift
//  PrivateMessanger
//
//  Created by MohammavDev on 4/22/26.
//

import Foundation




public extension Dictionary where Key == String, Value == String {
    ///Creates an array of URLQueryItem s from this dictionary
    var toQueryItem : [URLQueryItem] {
        self.map{ URLQueryItem(name: $0.key, value: $0.value)}
    }
}
