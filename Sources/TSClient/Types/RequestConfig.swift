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
///This will let you do customization:
///```swift
///let session = URLSession(configuration: sessionConfigs)
///let config = RequestConfig(server:.myServer,client: session)
///try await MySampleRoute.send("test",config : config)
///```
///
///You can also mock your HttpClient in order test your app:
///```swift
///struct MockHttpClient : HttpClient {
/// func upload(for: URLRequest, from: Data, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
///     let bool: Bool = true
///     let urlResponse = URLResponse()
///
///     let data = try! JSONEncoder().encode(bool)
///     return (data, urlResponse)
///}
/// //....
///}
///```
public struct RequestConfig<C : _HttpClientable> : Sendable  where C : Sendable {
    
    public let server : ServerConfiguration
    
    public let httpClient : C
    
    public let urlSafetyCheckMode : URLCreationMode
    
    public let delegate : (any URLSessionTaskDelegate)?
    
    public init(server : ServerConfiguration , client : C , delegate : (any URLSessionTaskDelegate)? = nil ,urlSafetyCheckMode : URLCreationMode  = .safe){
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
    static var local: RequestConfig<URLSession> {
        RequestConfig(server: .local, client: .shared, urlSafetyCheckMode: .safe)
    }
    ///Uses  URLSession.shared as httpClient , and safe mode for url checking
    static func server(_ server : ServerConfiguration) -> RequestConfig<URLSession>{
        return RequestConfig(server: server, client: .shared, urlSafetyCheckMode: .safe)
    }
}


