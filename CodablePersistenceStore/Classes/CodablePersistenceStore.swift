//
//  CodablePersistenceStore.swift
//  CodablePersistenceStore
//
//  Created by Mario Zimmermann on 16.11.17.
//

import Foundation
import Disk

public typealias PersistableType = CanBePersistedProtocol

open class CodablePersistenceStore: CodablePersistenceStoreProtocol {

    var rootName: String?
    
    /// Creates a default root folder.
    public init() {}
    
    /// Use this initializer if you want to create your own root folder.
    ///
    /// - Parameter rootName: The name of your root folder.
    public init(rootName: String?){
        self.rootName = rootName
    }
    
    /// Use this method to check if the provided object is persistable.
    ///
    /// - Parameter object: Any Object you'd like to check.
    /// - Returns: Boolean
    public func isResponsible(for object: Any) -> Bool {
        return object is PersistableType
    }
    
    /// Use this method to check if the provided type is persistable.
    ///
    /// - Parameter type: Any Type you'd like to check
    /// - Returns: Boolean
    public func isResponsible(forType type: Any.Type) -> Bool {
        let result = type.self is PersistableType.Type
        return result
    }
    
    /// Use this method to persist your desired item.
    ///
    /// - Parameter item: Any Item which implements the PersistableType Protocol.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func persist<T>(_ item: T!) throws where T : PersistableType {
        
        let id = item.identifier()
        let filePath = self.createPathFrom(type: T.self, id: id)
        print(filePath)
        
        do {
            try Disk.save(item, to: .caches, as: filePath)
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CannotUseProvidedItem(item: item, includedError: error)
        }
    }
    
    /// Use this method to persist your desired item.
    ///
    /// - Parameters:
    ///   - item: Any Item which implements the PersistableType Protocol.
    ///   - completion: Just a closure to do things afterwards.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func persist<T>(_ item: T!, completion: @escaping () -> ()) throws where T : PersistableType {
        
        let id = item.identifier()
        let filePath = self.createPathFrom(type: T.self, id: id)
        
        do {
            try Disk.save(item, to: .caches, as: filePath)
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CannotUseProvidedItem(item: item, includedError: error)
        }
    }
    
    /// Use this method to delete an item.
    ///
    /// - Parameter item: Any item which is already in the store.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func delete<T>(_ item: T!) throws where T : PersistableType {
        
        let id = item.identifier()
        let filePath = self.createPathFrom(type: T.self, id: id)
        
        do {
            try Disk.remove(filePath, from: .caches)
        } catch let error as NSError {
           throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: id, error: error)
        }
    }
    
    /// Use this method to delete an item.
    ///
    /// - Parameters:
    ///   - item: Any item which is already in the store.
    ///   - completion: Just a closure to do things afterwards.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func delete<T>(_ item: T!, completion: @escaping () -> ()) throws where T : PersistableType {
        
        let id = item.identifier()
        let filePath = self.createPathFrom(type: T.self, id: id)
        
        do {
            try Disk.remove(filePath, from: .caches)
            completion()
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: id, error: error)
        }
    }
    
    /// Use this method to delete an item.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of your item.
    ///   - type: Persistable Type
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func delete<T>(_ identifier: String, type: T.Type) throws where T : PersistableType {
        
        let filePath = self.createPathFrom(type: type, id: identifier)
        
        do {
            try Disk.remove(filePath, from: .caches)
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: identifier, error: error)
        }
    }
    
    /// Use this method to delete an item.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of your item.
    ///   - type: Persistable Type
    ///   - completion: Just a closure to do things afterwards.
    /// - Throws: An Error containing the localized description, localized failure reason and localized
    public func delete<T>(_ identifier: String, type: T.Type, completion: @escaping () -> ()) throws where T : PersistableType {
        
        let filePath = self.createPathFrom(type: type, id: identifier)
        
        do {
            try Disk.remove(filePath, from: .caches)
            completion()
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: identifier, error: error)
        }
    }
    
    public func get<T>(_ identifier: String, type: T.Type) throws -> T? where T : PersistableType {
        
        let finalPath = self.createPathFrom(type: type, id: identifier)
        
        do {
            let unarchivedData = try Disk.retrieve(finalPath, from: .caches, as: type.self)
            return unarchivedData
        } catch let error as NSError {
           throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: identifier, error: error)
        }
    }
    
    public func get<T>(_ identifier: String, type: T.Type, completion: @escaping (T?) -> Void) throws where T : PersistableType {
        
        let filePath = self.createPathFrom(type: type, id: identifier)
        
        do {
            let storedData = try Disk.retrieve(filePath, from: .caches, as: type.self)
            completion(storedData)
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: identifier, error: error)
        }
    }
    
    public func getAll<T>(_ type: T.Type) throws -> [T] where T : PersistableType {
        
        let finalPath = self.createPathFrom(type: type, id: nil)
        let jsonDecoder = JSONDecoder()

        var _decodedJSON: [T] = [T]()
        
        do {
            let storedData = try Disk.retrieve(finalPath, from: .caches, as: [Data].self)
            
            for item in storedData {
                let obj = try! jsonDecoder.decode(T.self, from: item)
                print(obj)
                _decodedJSON.append(obj)
            }
            return _decodedJSON
        } catch let _ as NSError {
            throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
        }
    }
    
    public func getAll<T>(_ type: T.Type, completion: @escaping ([T]) -> Void) throws where T : PersistableType {
        
        let finalPath = self.createPathFrom(type: type, id: nil)
        let jsonDecoder = JSONDecoder()
        
        var _decodedJSON: [T] = [T]()
        
        do {
            let storedData = try Disk.retrieve(finalPath, from: .caches, as: [Data].self)
            
            for item in storedData {
                let obj = try! jsonDecoder.decode(T.self, from: item)
                print(obj)
                _decodedJSON.append(obj)
            }
            completion(_decodedJSON)
        } catch let _ as NSError {
            throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
        }
    }
    
    public func filter<T>(_ type: T.Type, includeElement: @escaping (T) -> Bool) throws -> [T] where T : PersistableType {
        
        do {
            let storedData = try self.getAll(type)
            let filtered = storedData.filter(includeElement)
            return filtered
        } catch {
            throw CodablePersistenceStoreErrors.CannotUseType(type: T.Type.self, inStoreWithType: PersistableType.Type.self)
        }
    }
    
    public func filter<T>(_ type: T.Type, includeElement: @escaping (T) -> Bool, completion: @escaping ([T]) -> Void) throws where T : PersistableType {
        
        do {
            let storedData = try self.getAll(type)
            let filtered = storedData.filter(includeElement)
            completion(filtered)
        } catch {
            throw CodablePersistenceStoreErrors.CannotUseType(type: T.Type.self, inStoreWithType: PersistableType.Type.self)
        }
    }
    
    public func exists<T>(_ item: T) -> Bool where T : PersistableType {
        let id = item.identifier()
        let filePath = self.createPathFrom(type: T.self, id: id)
        let bool = Disk.exists(filePath, in: .caches)
        return bool
    }
    
    public func exists<T>(_ item: T!, completion: @escaping (Bool) -> Void) where T : PersistableType {
        let id = item.identifier()
        let filePath = self.createPathFrom(type: T.self, id: id)
        let bool = Disk.exists(filePath, in: .caches)
        completion(bool)
    }
    
    public func exists<T>(_ identifier: String, type: T.Type) -> Bool where T : PersistableType {
        let filePath = self.createPathFrom(type: type, id: identifier)
        let bool = Disk.exists(filePath, in: .caches)
        return bool
    }
    
    public func exists<T>(_ identifier: String, type: T.Type, completion: @escaping (Bool) -> Void) where T : PersistableType {
        let filePath = self.createPathFrom(type: type, id: identifier)
        let bool = Disk.exists(filePath, in: .caches)
        completion(bool)
    }
    
    public func cacheClear() throws {
        do {
            try Disk.clear(.caches)
        } catch let error as NSError {
            CodablePersistenceStoreErrors.CouldntClearCache(error: error)
        }
    }
    
    internal func createPathFrom<T>(type: T.Type, id: String?) -> String where T : PersistableType {
        let pathName: String = String(describing: type).lowercased()
        let id = id == nil ? "" : "/\(id!).json"
        let filePath: String = "\(self.rootName ?? "xmari0")/\(pathName)\(id)"
        return filePath
    }
}

