import Testing
import TSShared
import Foundation
#if os(Linux)
import FoundationNetworking
#endif

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


enum SampleHTMLRoute : HTMLRoute {
    typealias InputData = String
    
    static let path: TSShared.ServerPath = "user"
    
    
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

@Test("URLCreationMode test")
func testURLCreationMode() throws{
    
    let path = try ServerPath(string: "user/:id/name/:some")
    
    let value = try path.urlValidPath(with: ["first"], mode: .unchecked)
    #expect(value == "user/first/name/:some")
    
    let value2 = try path.urlValidPath(with: ["first", "second","third"], mode: .unchecked)
    #expect(value2 == "user/first/name/second/third")
    
    
    let path2 = try ServerPath(string: "user/:name/**")
    
    let value3 = try path2.urlValidPath(with: ["one","two","three","four"], mode: .checked)
    #expect(value3 == "user/one/two/three/four")
    
    let value4 = try path2.urlValidPath(with: ["one","two","three","four"], mode: .unchecked)
    #expect("user/one/two/three/four" == value4)
}

@Test("test CommonHeader tests")
func testCommonHeader() throws {
    
    var request = URLRequest(url: .moviesDirectory)
    
    request["foo"] = "bar"
    
    let fetched = try #require(request.value(forHTTPHeaderField: "foo"))
    #expect(fetched == "bar")
    
    let dic = [ "MyValue" : "hello"]
    let response = HTTPURLResponse(url: .moviesDirectory, statusCode: 200, httpVersion: nil, headerFields: dic)!
    
    
    #expect(response["MyValue"] == "hello")
    
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
