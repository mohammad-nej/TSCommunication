//
//  Content Type.swift
//  TSShared
//
//  Created by MohammavDev on 4/9/26.
//

///Content type of a request that is being sent to the server
public struct ContentType: RawRepresentable, ExpressibleByStringLiteral, Sendable, Equatable , Hashable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
}

public extension ContentType {
    
    // MARK: - JSON
    
    ///application/json
    static let json: Self = "application/json"
    
    ///application/ld+json
    static let jsonLD: Self = "application/ld+json"
    
    // MARK: - Text
    static let plainText: Self = "text/plain"
    static let html: Self = "text/html"
    
    // MARK: - Form
    static let formURLEncoded: Self = "application/x-www-form-urlencoded"
    static let multipartFormData : Self = "multipart/form-data"
    
    
    // MARK: - Binary
    static let binary: Self = "application/octet-stream"
    
    // MARK: - Images
    static let png: Self = "image/png"
    static let jpeg: Self = "image/jpeg"
    
    // MARK: - Video
    static let mp4: Self = "video/mp4"
    
    // MARK: - Audio
    static let mp3: Self = "audio/mpeg"
    
    // MARK: - Documents
    static let pdf: Self = "application/pdf"
    
    // MARK: - Archives
    static let zip: Self = "application/zip"
    
  
}
