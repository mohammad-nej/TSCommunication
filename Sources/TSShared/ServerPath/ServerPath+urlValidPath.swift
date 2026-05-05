//
//  Untitled.swift
//  PrivateMessanger
//
//  Created by MohammavDev on 4/21/26.
//


import Foundation







public extension ServerPath {
    
    ///Creates a valid URLComponent string from itself by inserting parameters in the string
    func urlValidPath(with parameters : [String], mode : URLCreationMode) throws -> String {
        var urlPath: [String] = []
       
        var expectedParams = 0
        var hasCatchAll = false
        
        if mode == .checked{
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
                //in case of extra parameters
                guard parameterIndex < parameters.count else {
                    logger.warning("Extra amount of parameters in path : \(self.description)")
                    continue
                }
                urlPath.append(parameters[parameterIndex])
                parameterIndex += 1
            }
        }
        
        
        if parameterIndex != parameters.count {
            logger.warning("Insufficient amount of parameters in path : \(self.description), Expected : \(parameters.count) , received : \(parameterIndex.description)")
        }
        
        return urlPath.joined(separator: "/")
    }
}
