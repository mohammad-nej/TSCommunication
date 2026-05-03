//
//  HttpMethod.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

///Common Http methods
///
///This is an exact replica of Vapor.HTTPMethod enum, we didn't want to use Vapor version cause that would have forced us to add Vapor
///to the dependencies of our shared target.
public enum HttpMethod : Codable , Sendable , Equatable , Hashable{
    
    case GET
    case PUT
    case ACL
    case HEAD
    case POST
    case COPY
    case LOCK
    case MOVE
    case BIND
    case LINK
    case PATCH
    case TRACE
    case MKCOL
    case MERGE
    case PURGE
    case NOTIFY
    case SEARCH
    case UNLOCK
    case REBIND
    case UNBIND
    case REPORT
    case DELETE
    case UNLINK
    case CONNECT
    case MSEARCH
    case OPTIONS
    case PROPFIND
    case CHECKOUT
    case PROPPATCH
    case SUBSCRIBE
    case MKCALENDAR
    case MKACTIVITY
    case UNSUBSCRIBE
    case SOURCE
    case RAW(value: String)

}
