//
//  sdf.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

///transfer method used by the vapor server
public enum FileTransferMethod : Sendable , Equatable , Hashable , Codable {
    
    ///Size of a request 
    public enum Size :Sendable , Codable, Equatable, Hashable {
        case kb(Int) , mb(Int) , gb(Int) , tb(Int)
    }
    
    ///Used when you want to stream a file to you vapor server
    case stream
    
    ///max amount of request size in this route.
    case  collect(Size)
    
    ///The vapor default option
    case `default`
}


extension FileTransferMethod.Size : CustomStringConvertible {
    public var description: String{
        switch self {
        case .gb(let value):
            "\(value)gb"
        case .mb(let value):
            "\(value)mb"
        case .kb(let value):
            "\(value)kb"
        case .tb(let value):
            "\(value)tb"
        }
    }
    
}

