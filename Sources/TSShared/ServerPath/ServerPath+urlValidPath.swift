//
//  Untitled.swift
//  PrivateMessanger
//
//  Created by MohammavDev on 4/21/26.
//


import Foundation


public enum URLConversionError: Error {
    case insufficientAmountOfParameters, extraAmountOfParameters
}

///Indicates whether you want strict checking or not?
///
///`URLCreationMode.safe` will  ensure that the amount of parameters you passed in, is equal to the amount of parameters your `ServerPath` needs.
///
///
///- Warning: Using `unsafe` mode will slightly improve performance but it might cause your app to crash if you pass in insufficient amount of parameters.
public enum URLCreationMode : Equatable , Hashable , Sendable{
    ///In safe mode, url parameters count are checked to match the `ServerPath` required amount of parameters
    ///
    ///This will make sure that you don't accidentally miss a parameter or don't crash because of passing insufficient amount of parameters
    case safe
    
    ///Completely disabling bound checking
    ///
    /// - Warning: While disabling bound checking could slightly speed up the process, function might crash if you pass in insufficient amount of  parameters
    case unsafe
}


public extension ServerPath {
    
    ///Creates a valid URLComponent string from itself by inserting parameters in the string
    ///
    /// By default this function will makes sure that you have passed the right amount of parameters. However, you can disable this
    /// behavior by pass ``URLCreationMode.unsafe`` to it's ``mode`` input value.
    /// - Warning: URLCreationMode.unsafe will crash at runtime if you don't pass enough amount of parameters.
    func urlValidPath(with parameters : [String], mode : URLCreationMode) throws -> String {
        var urlPath: [String] = []
       
        var expectedParams = 0
        var hasCatchAll = false
        
        if mode == .safe{
            //bound checking
            for part in self.parts {
                if part == .catchAll {
                    hasCatchAll = true
                    expectedParams += 1
                } else if part == .anything || part.isParameter {
                    expectedParams += 1
                }
            }
            
            if parameters.count < expectedParams {
                throw URLConversionError.insufficientAmountOfParameters
            }
            if hasCatchAll {
                guard parameters.count >= expectedParams else {
                    throw URLConversionError.insufficientAmountOfParameters
                }
            } else {
                guard parameters.count == expectedParams else {
                    throw URLConversionError.extraAmountOfParameters
                }
            }
        }
        var parameterIndex = 0
        
        for part in self.parts {
            if part.isPath {
                urlPath.append(part.value)
            } else if part == .catchAll {
                urlPath.append(contentsOf: parameters[parameterIndex...])
                parameterIndex = parameters.count
                break
            } else {
                urlPath.append(parameters[parameterIndex])
                parameterIndex += 1
            }
        }
        
        return urlPath.joined(separator: "/")
    }
}
