//
//  Codable.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import Foundation

///Responsible for decoding/encoding data
public protocol EncoderDecoder {
    static var encoder : JSONEncoder { get }
    static var decoder : JSONDecoder { get }
  
}

