//
//  CleintBigFile+defaults.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//
import TSShared
import Foundation


public extension ClientLargeFileUploadable{
    static var encoder : JSONEncoder{
        Coding.encoder
    }
    
    static var decoder : JSONDecoder{
        Coding.decoder
    }
    
    static var method: HttpMethod { .POST }
    
    static var timeoutInterval : TimeInterval { 150 }
}
