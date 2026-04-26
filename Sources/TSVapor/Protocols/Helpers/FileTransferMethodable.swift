//
//  FileTransferMethodable.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import TSShared
import Vapor


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
