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
    
    func update<T: PersistableType>(_ newItem: T!) throws
    func update<T: PersistableType>(_ newItem: T!, completion:@escaping () -> ()) throws

    func exists<T: PersistableType>(_ item : T) -> Bool
    func exists<T: PersistableType>(_ item : T!, completion: @escaping (_ exists: Bool) -> Void)
    func exists<T: PersistableType>(_ identifier : String,type : T.Type) -> Bool
    func exists<T: PersistableType>(_ identifier : String,type : T.Type,  completion: @escaping (_ exists: Bool) -> Void)
    func exists<T: PersistableType>(_ type: T.Type) -> Bool
    func exists<T: PersistableType>(_ type: T.Type, completion: @escaping (_ exists: Bool) -> Void)

    func filter<T: PersistableType>(_ type: T.Type, includeElement: @escaping (T) -> Bool) throws -> [T]
    func filter<T: PersistableType>(_ type: T.Type, includeElement: @escaping (T) -> Bool, completion: @escaping (_ items: [T]) -> Void) throws
    
    func cacheClear() throws
}
