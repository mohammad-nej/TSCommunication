//
//  FileTransferMethodable.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import TSShared
import Vapor


///Method that is used by vapor to collect body of request
///
///All HTTP routes already conform to this protocol, you don't need to conform directly
public protocol FileTransferMethodable {
    static var transferMethod: FileTransferMethod { get }
}

extension FileTransferMethodable {
    public static  var transferMethod: FileTransferMethod { .default }
}



public extension FileTransferMethod {
     var toVaporSteamStrategy : HTTPBodyStreamStrategy {
        switch self {
        case .collect(let size):
            let byteCount = ByteCount(stringLiteral: "\(size.description)")
            return .collect(maxSize: byteCount)
        case .stream:
            return .stream
        case .default:
            return .collect
        }
    }
}
