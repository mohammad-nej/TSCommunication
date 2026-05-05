//
//  RequestConfig.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/25/26.
//

import Foundation
import TSShared


///Combines the configuration of a single request
///
///Contains all the information needed to create your request. This type also contains a ``HttpClient`` which is used to
///send your request through network, since ``URLSession`` is already extended to be an``HttpClient``, you can pass your
///custom `URLSession` object in, if you want.
///```swift
///let session = URLSession(configuration: sessionConfigs)
///let config = RequestConfig(server:.myServer,client: session)
///try await MySampleRoute.send("test",config : config)
///```
///
public struct RequestConfig<C : _HttpClientable> : Sendable  where C : Sendable {
    
    public let server : ServerConfiguration
    
    public let httpClient : C
    
    public let urlSafetyCheckMode : URLCreationMode
    
    public let delegate : (any URLSessionTaskDelegate)?
    
    public init(server : ServerConfiguration , client : C , delegate : (any URLSessionTaskDelegate)? = nil ,urlSafetyCheckMode : URLCreationMode  = .checked){
        self.server = server
        self.httpClient = client
        self.urlSafetyCheckMode = urlSafetyCheckMode
        self.delegate = delegate
        
    }
    
    public init(server : ServerConfiguration , delegate : (any URLSessionTaskDelegate)? = nil ,urlSafetyCheckMode : URLCreationMode) where C == URLSession {
        self.server = server
        self.httpClient = .shared
        self.urlSafetyCheckMode = urlSafetyCheckMode
        self.delegate = delegate
    }
}

extension RequestConfig where C == URLSession {
    
    ///Uses localhost as server , URLSession.shared as httpClient , and safe mode for url checking
    public static var local: RequestConfig<URLSession> {
        RequestConfig(server: .local, client: .shared, urlSafetyCheckMode: .checked)
    }
    ///Uses  URLSession.shared as httpClient , and safe mode for url checking
    public static func server(_ server : ServerConfiguration) -> RequestConfig<URLSession>{
        return RequestConfig(server: server, client: .shared, urlSafetyCheckMode: .checked)
    }
}

