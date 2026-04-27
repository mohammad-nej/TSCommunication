//
//  RoutesBuilder+.swift
//  Whisper
//
//  Created by MohammavDev on 4/20/26.
//
import Vapor
import TSShared


extension RoutesBuilder{
    @discardableResult
    func add<T:GetHttpRoute>(_ route : T) -> Route where T : VaporRespondable{

        return self.on(T.method.asVaporHTTPMethod,
                T.path.vaporComponents,
                
                use: T.closure)
    }
}
