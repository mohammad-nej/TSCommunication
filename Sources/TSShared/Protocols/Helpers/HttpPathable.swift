//
//  HttpPathable.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/1/26.
//

import Foundation

public protocol HttpPathable : IdentifiableRoute, Sendable , Failable , EncoderDecoder{
    
    associatedtype Failure : ServerError  = VaporError
    associatedtype Coding : EncoderDecoder = DefaultCoding
    
    static var contentType : ContentType { get }
    static var path : ServerPath { get }
    static var method: HttpMethod { get }
}
extension HttpPathable{
    public static var routeId: RouteId {
        .init(path: path, method: method)
    }
    
    public static var contentType: ContentType {
        .json
    }
    
    ///Default encoder used to encode inputData
    public static var encoder: JSONEncoder {
        Coding.encoder
    }
    
    ///Default decoder used to decode OutputData
    public static var decoder: JSONDecoder {
        Coding.decoder
    }
}
