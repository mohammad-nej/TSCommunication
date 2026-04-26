//
//  ServerPath.swift
//  Whisper
//
//  Created by MohammavDev on 4/21/26.
//

import Foundation
import Vapor
import TSShared





extension ServerPath {
    
    var vaporComponents : [PathComponent]{
        self.parts
            .map{ part in
                if part == .anything{
                    return PathComponent.anything
                }else if part == .catchAll{
                    return PathComponent.catchall
                }else if part.isPath {
                    return PathComponent.constant(part.value)
                }else if part.isParameter{
                    return PathComponent.parameter(part.correctedValue)
                }else{
                    fatalError("Impossible state !!!")
                }
            }
        
    }
    
}

extension PathComponent {
    func toServerPath() -> ServerPath {
       //since we are converting from Vapor path components , it's impossible to fail
        try! ServerPath(string: self.description)
    }
    
    var isParameter : Bool {
        if self == .anything {
            return true
        }
        if self == .catchall {
            return true
        }
        return self.description.hasPrefix(":")
    }
    
    var isPath : Bool {
        !isParameter
    }
}
