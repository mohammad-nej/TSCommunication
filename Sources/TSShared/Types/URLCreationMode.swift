//
//  URLCreationMode.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/4/26.
//


///Indicates whether you want strict checking or not?
///
///`URLCreationMode.checked` will  ensure that the amount of parameters you passed in, is equal to the amount of parameters your `ServerPath` needs.
public enum URLCreationMode : Equatable , Hashable , Sendable{
    ///In safe mode, url parameters count are checked to match the `ServerPath` required amount of parameters
    ///
    ///This will make sure that you don't accidentally pass incorrect amount of parameters.
    case checked
    
    
    ///Completely disabling bound checking
    ///
    ///Extra parameters will be ignored in this mode
    case unchecked
}
