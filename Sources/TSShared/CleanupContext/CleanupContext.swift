//
//  CleanupContext.swift
//  TSShared
//
//  Created by MohammavDev on 4/17/26.
//

///This object can be used to do clean ups in case of any  failure.
///
///Clean up closures can be added using `add` function.  all closures added to the object
///will run in **REVERSE** order using `run` function.
///
///Example:
///```swift
///var cleaner = CleanupContext()
///do{
/// let value = try someFailingJob()
/// cleaner.add{
///  //rollback changes...
/// }
/// try anotherFailingJob()
/// cleaner.add{
///  //some rollbacks
/// }
///  cleaner.clear()
///}catch{
/// cleaner.run()
/// ....
///}
///```
public struct CleanupContext : Sendable{
    
    public init() {}
    
    var actions : [ @Sendable () async -> Void] = []
    
    ///Removes all rollback closures in the context
    public mutating func clear(){
        actions.removeAll()
    }
    
    ///Adds rollback closures to the context
    ///
    ///Example:
    ///```swift
    /////Action
    ///try FileManager.default.createFile(atPath: path, contents: data)
    ///
    /////Rollback
    ///cleaner.add{
    /// try? FileManager.default.removeItem(atPath: path)
    ///}
    ///```
    public mutating func add(_ action: @Sendable @escaping () async -> Void){
        actions.append(action)
        
    }
    
    ///Runs all rollback closures in **reverse ** order
    public func run() async{
        for action in actions.reversed(){
            await action()
        }
    }
}
