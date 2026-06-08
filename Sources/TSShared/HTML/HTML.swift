//
//  HTML.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/29/26.
//



public struct HTML : Sendable , Equatable , Hashable , Codable {
    public init(_ html: String) {
        self.html = html
    }
    
    public var html : String
}


public extension HTML {
    ///Creates a sample HTML string with a title and a body
    static func sample(title : String = "Sample HTML page", _ body : String) -> HTML {
        let template = """
            <!doctype html>
            <html>
              <head>
                <title>\(title)</title>
              </head>
              <body>
                \(body)
              </body>
            </html>
            """
        return HTML(template)
    }
}


extension HTML : ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.html = value
    }
}
