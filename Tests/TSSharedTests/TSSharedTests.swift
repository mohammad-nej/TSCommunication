import Testing
import TSShared


struct MySampleRoute : HttpRoute {
    typealias InputData = String
    
    typealias OutputData = String
    
    static let path: TSShared.ServerPath = "user"
    
    static let method: TSShared.HttpMethod = .get
    
    static let contentType: ContentType = .binary
    
}

@Test func fileNameTests() async throws {
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
    
    let unsafe = FileName.unsafe("unsafeFilename.txt")
    #expect(unsafe.fullname == "unsafeFilename.txt")
    #expect(unsafe.extension == "txt")
    #expect(unsafe.name == "unsafeFilename")
    
    #expect(throws: FileName.FileNameError.empty){
        try FileName(name:"")
        
    }
    
    #expect(throws: FileName.FileNameError.noExtension){
        try FileName(name:"mysample")
    }
    
    #expect(throws: FileName.FileNameError.specialCharacter) {
        try FileName(name:"m/nae.txt")
    }
}
