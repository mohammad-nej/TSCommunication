//
//  ServerHTMLRoute+defaults.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/29/26.
//

import TSShared

public extension ServerHTMLRoute {
    
    //Default is set to post , you can override it by defining a value in your concrete type
    static var method: HttpMethod { .POST }
    
    ///Max size of the file that vapor will collect
    static var transferMethod: FileTransferMethod { .default }
    
}
