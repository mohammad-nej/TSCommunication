//
//  RoutesBuilder+.swift
//  Whisper
//
//  Created by MohammavDev on 4/20/26.
//
import Vapor
import TSShared

//vapor route builder
extension RoutesBuilder{
    @discardableResult
    func add<T:AnyHttpRoute>(_ route : T.Type) -> Route{

        let transferMethod : HTTPBodyStreamStrategy
        if let fileTransferable = route as? FileTransferMethodable.Type{
            transferMethod = fileTransferable.transferMethod.toVaporSteamStrategy
        }else{
            transferMethod = .collect
        }
        
        return self.on(T.method.asVaporHTTPMethod,
                T.path.vaporComponents,
                body: transferMethod,
                use: T.closure)
    }
    
    @discardableResult
    func add<T:ServerWebSocket>(_ route : T.Type) -> Route{
        let path = T.path.vaporComponents
        let size : WebSocketMaxFrameSize
       
        if let value = T.maxFrameSize{
            size = .init(integerLiteral: value)
        }else{
            size = .default
        }
        if let shouldUpgrade = T.shouldUpgrade{
            return self.webSocket(
                path,
                maxFrameSize: size,
                shouldUpgrade: shouldUpgrade,
                onUpgrade: T.onUpgrade)
        }else{
            return self.webSocket(path, maxFrameSize: size,
                                  onUpgrade: T.onUpgrade)
        }
    }
}
