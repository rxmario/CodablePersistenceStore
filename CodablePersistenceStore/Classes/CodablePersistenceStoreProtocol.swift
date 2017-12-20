//
//  CodablePersistenceStoreProtocol.swift
//  CodablePersistenceStore
//
//  Created by Mario Zimmermann on 16.11.17.
//

import Foundation
import Disk

public protocol CodablePersistenceStoreProtocol {
    
    func isResponsible(for object: Any) -> Bool
    func isResponsible(forType type: Any.Type) -> Bool
    
    func persist<T: PersistableType>(_ item: T!) throws
    func persist<T: PersistableType>(_ item: T!,completion: @escaping () -> ()) throws
    
    func delete<T: PersistableType>(_ item: T!) throws
    func delete<T: PersistableType>(_ item: T!, completion: @escaping () -> ()) throws
    func delete<T: PersistableType>(_ identifier: String, type: T.Type) throws
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
    func exists<T: PersistableType>(_ item : T!, completion: @escaping (_ exists: Bool) -> Void)
    func exists<T: PersistableType>(_ identifier : String,type : T.Type) -> Bool
    func exists<T: PersistableType>(_ identifier : String,type : T.Type,  completion: @escaping (_ exists: Bool) -> Void) 
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

