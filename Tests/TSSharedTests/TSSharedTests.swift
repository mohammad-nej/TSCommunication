import Testing
import TSShared
import Foundation

enum MySampleRoute : HttpRoute {
    typealias InputData = String
    
    typealias OutputData = String
    
    
    static let path: TSShared.ServerPath = "user"
    
    static let method: TSShared.HttpMethod = .GET
    
    static let contentType: ContentType = .binary
    
}
enum MyWebSocketRoute : WebSocketRoute {
    static var path: TSShared.ServerPath { "webSocket" }
}
enum DownloadMovie : FileDownloadable {
    static var path: TSShared.ServerPath { "downloadFile/:id" }
}
enum SampleFileUploadable : FileUploadable {
    typealias InputData = String
    
    typealias OutputData = Data
    
    static var path: TSShared.ServerPath { "user" }
    
    
}

struct SampleLargeFile : LargeFileUploadable {
    
    typealias OutputData = UUID
    
    static var path: TSShared.ServerPath { "some/large/path"}
    
    
}

@Test("PathPart tests")
func testPathPart() throws {
    #expect(throws:ServerPathError.invalidPath){
        try PathPart(value: "::invalid")
    }
    
    _ = try PathPart(value: "users")
    
    
    
    #expect(throws: ServerPathError.invalidPath){
        try PathPart(value: "/users12/_route")

    }
    #expect(throws:ServerPathError.invalidPath){
        try PathPart(value: "/in:valid")
    }
    
    #expect(throws:ServerPathError.invalidPath){
        try PathPart(value: "/&invalid")
    }
    
    #expect(throws:ServerPathError.invalidPath){
        try PathPart(value: "//&invalid")
    }
    
    _ = PathPart(unchecked: "//&invalid")
    
    let customRegex = /\d+/
    _ = try PathPart("123", using: customRegex)
    
    #expect(throws: ServerPathError.invalidPath) {
        try PathPart("mamamd", using: customRegex)
    }
    
}

@Test("ServerPath test")
func serverPathTests() throws {
    
    _ = try ServerPath(string: "/users12/_route123/*/**")
    
    let customRegex = /\d+/
    _ = try ServerPath("/123/435/99", validation: customRegex)
    
    #expect(throws: ServerPathError.invalidPath) {
        try ServerPath("123/m/123", validation: customRegex)
    }
    
}

@Test("Test FileName")
func fileNameTests() throws {
    let filename : FileName = "myfile.txt"
    
    
    
    #expect(filename.fullname == "myfile.txt")
    #expect(filename.extension == "txt")
    #expect(filename.name == "myfile")
    
    let second = try FileName(name:"myfile.someformat.something.txt")
    
    #expect(second.extension == "txt")
    #expect(second.name == "myfile.someformat.something")
    
    let text = try FileName.txt("sample")
    #expect(text.fullname == "sample.txt")
    #expect(text.extension == "txt")
    #expect(text.name == "sample")
    
    let unsafe = FileName.unchecked("unsafeFilename.txt")
    #expect(unsafe.fullname == "unsafeFilename.txt")
    #expect(unsafe.extension == "txt")
    #expect(unsafe.name == "unsafeFilename")
    
    #expect(throws: FileNameError.invlaidFileName){
        try FileName(name:"")
        
    }
    
    #expect(throws: FileNameError.invlaidFileName){
        try FileName(name:"mysample")
    }
    
    #expect(throws: FileNameError.invlaidFileName) {
        try FileName(name:"m/nae.txt")
    }
    
    let custom = /\d+.\w+/
    
    _ = try FileName("123.txt", validation: custom)
    #expect(throws: FileNameError.invlaidFileName){
        try FileName("mamad.txt", validation: custom)
    }
}
