//
//  ServerResponse.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//
import Foundation
import TSShared


public enum ServerResponseError : Error , LocalizedError {
    case unknownFormat(Data)
    
    public var errorDescription: String? {
        "Data received from server is in unknown format."
    }
}



///Hold information of a response coming back from server.
///
///This is basically an abstraction over (Data,URLResponse) that comes back from request.
///```swift
/////Getting output, if you don't care about server error
///try await GetDataRoute.get(parameters : [], config:config)
///                             .asOutput()
/////If you only want the error
///try await GetDataRoute.get(parameters : [], config:config)
///                             .asServerError()
/////if you want either of them.
///try await GetDataRoute.get(parameters : [], config:config)
///                             .asResult() //-> Result<OutputData,Failure>
///```
public struct ServerResponse< T : GetHttpRoute> : Sendable , Equatable , Hashable where T : EncoderDecoder{
    
    
    public let data :  Data
    public let response : URLResponse
    
    public init(_ type : T.Type , data : Data , response : URLResponse){
        self.data = data
        self.response = response
    }
    
    ///Converts ServerResponse to the OutputData of this route if possible.
    public var asOutput : T.OutputData  {
        get throws{
            try T.decoder.decode(T.OutputData.self, from: self.data)
        }
    }
    
    ///Converts ServerResponse to the Failure type of this route if possible.
    public var asServerError : T.Failure {
        get throws{
            return  try T.failureDecoder.decode(T.Failure.self, from: data)
        }
    }
   
    ///If you prefer to work with (Data,URLResponse) tuple
    public var asTuple : (Data,URLResponse) {
        return (data,response)
    }
    
    ///Returns a Result type containing either output or error emitted from server.
    ///
    /// - throws: Will throw `ServerResponseError.unknownFormat(Data)` error if responses data is not in correct format.
    public var asResult  : Result<T.OutputData,T.Failure> {
        get throws{
            let output = try? self.asOutput
            if let output{
                return .success(output)
            }
            
            let failure = try? self.asServerError
            if let failure{
                return .failure(failure)
            }
            
            throw ServerResponseError.unknownFormat(data)
        }
    }
}
