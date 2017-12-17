//
//  CodablePersistenceStoreProtocol.swift
//  CodablePersistenceStore
//
//  Created by Mario Zimmermann on 16.11.17.
//

import Foundation
import Disk

public protocol CodablePersistenceStoreProtocol {
        
    /// Use this method to check if the provided object is persistable.
    ///
    /// - Parameter object: Any Object you'd like to check.
    /// - Returns: Boolean
    func isResponsible(for object: Any) -> Bool
    /// Use this method to check if the provided type is persistable
    ///
    /// - Parameter type: Any Type you'd like to check
    /// - Returns: Boolean
    func isResponsible(forType type: Any.Type) -> Bool
    /// Use this method to persist your desired item.
    ///
    /// - Parameter item: Any Item which implements the PersistableType Protocol.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    func persist<T: PersistableType>(_ item: T!) throws
    /// Use this method to persist your desired item.
    ///
    /// - Parameters:
    ///   - item: Any Item which implements the PersistableType Protocol.
    ///   - completion: Just a closure to do things afterwards.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    func persist<T: PersistableType>(_ item: T!,completion: @escaping () -> ()) throws
    /// Use this method to delete an item.
    ///
    /// - Parameter item: Any item which is already in the store.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    func delete<T: PersistableType>(_ item: T!) throws
    /// Use this method to delete an item.
    ///
    /// - Parameters:
    ///   - item: Any item which is already in the store.
    ///   - completion: Just a closure to do things afterwards.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    func delete<T: PersistableType>(_ item: T!, completion: @escaping () -> ()) throws
    /// Use this method to delete an item.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of your item.
    ///   - type: Persistable Type
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    func delete<T: PersistableType>(_ identifier: String, type: T.Type) throws
    /// Use this method to delete an item.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of your item.
    ///   - type: Persistable Type
    ///   - completion: Just a closure to do things afterwards.
    /// - Throws: An Error containing the localized description, localized failure reason and localized
    func delete<T: PersistableType>(_ identifier: String, type: T.Type, completion: @escaping () -> ()) throws

    func get<T: PersistableType>(_ identifier: String, type: T.Type) throws -> T?
    func get<T: PersistableType>(_ identifier: String, type: T.Type, completion: @escaping (_ item: T?) -> Void ) throws
    
    func getAll<T: PersistableType>(_ type: T.Type) throws -> [T]
    func getAll<T: PersistableType>(_ type: T.Type, completion: @escaping (_ items: [T]) -> Void) throws
//
//    func getAll<T>(_ viewName:String) throws ->[T]
//    func getAll<T>(_ viewName:String, completion: @escaping (_ items: [T]) -> Void) throws
//
//    func getAll<T>(_ viewName:String,groupName:String) throws ->[T]
//    func getAll<T>(_ viewName:String,groupName:String, completion: @escaping (_ items: [T]) -> Void) throws
//
    func exists<T: PersistableType>(_ item : T) -> Bool
//    func exists(_ item : Any!, completion: @escaping (_ exists: Bool) -> Void) throws
//    func exists(_ identifier : String,type : Any.Type) throws -> Bool
//    func exists(_ identifier : String,type : Any.Type,  completion: @escaping (_ exists: Bool) -> Void) throws
//
    func filter<T: PersistableType>(_ type: T.Type, includeElement: @escaping (T) -> Bool) throws -> [T]
    func filter<T: PersistableType>(_ type: T.Type, includeElement: @escaping (T) -> Bool, completion: @escaping (_ items: [T]) -> Void) throws
//
//    func addView<T>(_ viewName: String,
//                    groupingBlock: @escaping ((_ collection: String,
//        _ key: String,
//        _ object: T)->String?),
//
//                    sortingBlock: @escaping ((     _ group: String,
//        _ collection1: String,
//        _ key1: String,
//        _ object1: T,
//        _ collection2: String,
//        _ key2: String,
//        _ object2: T) -> ComparisonResult)) throws
    
    func cacheClear() throws
}

//public extension CodablePersistenceStoreProtocol {
//
//    public func version() -> Int {
//        return 0;
//    }
//
//    public func isResponsible(for object: Any) -> Bool{
//        return object is PersistableType
//    }
//
//    func isResponsible(forType type: Any.Type) -> Bool{
//        return type.self is PersistableType.Type
//    }
//
//    public func persist<T>(_ item: T!) throws {
//        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
//    }
//
//    public func persist<T>(_ item: T!,completion: @escaping () -> ()) throws {
//        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
//    }
//
//    public func delete<T>(_ item: T!) throws {
//        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
//    }
//
//    public func delete<T>(_ item: T!, completion: @escaping () -> ()) throws {
//        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
//    }
//
//    public func delete<T>(_ identifier: String, type: T.Type, completion: @escaping () -> ()) throws {
//        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
//    }
//
//    public func delete<T>(_ identifier: String, type: T.Type) throws {
//        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
//    }
//
//    public func get<T>(_ identifier: String) throws -> T? {
//        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
//    }
//
//    public func get<T>(_ identifier: String, completion: @escaping (_ item: T?) -> Void ) throws {
//        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
//    }
//
//    public func get<T>(_ identifier: String, type: T.Type) throws -> T? {
//        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
//    }
//
//    public func get<T>(_ identifier: String, type: T.Type, completion: @escaping (_ item: T?) -> Void ) throws {
//        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
//    }
//
////    public func getAll<T>(_ type: T.Type) throws -> [T] {
////        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
////    }
////
////    public func getAll<T>(_ type: T.Type, completion: @escaping (_ items: [T]) -> Void) throws {
////        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
////    }
////
////    public func getAll<T>(_ viewName:String) throws ->[T] {
////        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
////    }
////
////    public func getAll<T>(_ viewName:String, completion: @escaping (_ items: [T]) -> Void) throws {
////        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
////    }
////
////    public func getAll<T>(_ viewName:String,groupName:String) throws ->[T]  {
////        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
////    }
////
////    public func getAll<T>(_ viewName:String,groupName:String, completion: @escaping (_ items: [T]) -> Void) throws {
////        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
////    }
////
////    public func exists(_ item : Any!) throws -> Bool  {
////        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
////    }
////
////    public func exists(_ item : Any!, completion: @escaping (_ exists: Bool) -> Void) throws  {
////        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
////    }
////
////    public func exists(_ identifier : String,type : Any.Type) throws -> Bool  {
////        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
////    }
////
////    public func exists(_ identifier : String,type : Any.Type,  completion: @escaping (_ exists: Bool) -> Void) throws  {
////        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
////    }
////
////    public func filter<T>(_ type: T.Type, includeElement: @escaping (T) -> Bool) throws -> [T]  {
////        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
////    }
////
////    public func filter<T>(_ type: T.Type, includeElement: @escaping (T) -> Bool, completion: @escaping (_ items: [T]) -> Void) throws  {
////        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
////    }
////
////    public func addView<T>(_ viewName: String,
////                           groupingBlock: @escaping ((_ collection: String,
////        _ key: String,
////        _ object: T)->String?),
////
////                           sortingBlock: @escaping ((     _ group: String,
////        _ collection1: String,
////        _ key1: String,
////        _ object1: T,
////        _ collection2: String,
////        _ key2: String,
////        _ object2: T) -> ComparisonResult)) throws {
////
////        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
////    }
//    
//    
//}

