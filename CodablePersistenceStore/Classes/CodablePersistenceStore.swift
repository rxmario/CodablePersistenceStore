//
//  CodablePersistenceStore.swift
//  CodablePersistenceStore
//
//  Created by Mario Zimmermann on 16.11.17.
//

import Foundation
import Disk

public typealias PersistableType = Codable & CanBePersistedProtocol

//public protocol PersistableType: Persistable{}

open class CodablePersistenceStore: CodablePersistenceStoreProtocol {

    var prefix: String?
    
    public init(prefix: String){
        self.prefix = prefix
    }
    
    public func isResponsible(for object: Any) -> Bool {
        return object is PersistableType
    }
    
    public func isResponsible(forType type: Any.Type) -> Bool {
        let result = type.self is PersistableType.Type
        return result
    }
    
    
    public func persist<T>(_ item: T!) throws where T : PersistableType {
        
        let id = type(of: item).id()
        let filePath = self.createPathFrom(type: T.self, id: id)
        
        do {
            if self.exists(item) {
                try self.append(item)
            } else {
                try Disk.save(item, to: .caches, as: filePath)
            }
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CannotUseProvidedItem(item: item, includedError: error)
        }
    }
    
    public func persist<T>(_ item: T!, completion: @escaping () -> ()) throws where T : PersistableType {
        
        let id = type(of: item).id()
        let filePath = self.createPathFrom(type: T.self, id: id)
        
        do {
            if self.exists(item) {
                try self.append(item)
                completion()
            } else {
               try Disk.save(item, to: .caches, as: filePath)
                completion()
            }
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CannotUseProvidedItem(item: item, includedError: error)
        }
    }
    
    public func delete<T>(_ item: T!) throws where T : PersistableType {
        
        let id = type(of: item).id()
        let filePath = self.createPathFrom(type: T.self, id: id)
        
        do {
            try Disk.remove(filePath, from: .caches)
        } catch let error as NSError {
           throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: id, error: error)
        }
    }
    
    public func delete<T>(_ item: T!, completion: @escaping () -> ()) throws where T : PersistableType {
        
        let id = type(of: item).id()
        let filePath = self.createPathFrom(type: T.self, id: id)
        
        do {
            try Disk.remove(filePath, from: .caches)
            completion()
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: id, error: error)
        }
    }
    
    public func delete<T>(_ identifier: String, type: T.Type) throws where T : PersistableType {
        
        let filePath = self.createPathFrom(type: type, id: identifier)
        
        do {
            try Disk.remove(filePath, from: .caches)
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: identifier, error: error)
        }
    }
    
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
        
        let id = T.id()
        let finalPath = self.createPathFrom(type: type, id: id)
        
        do {
            let storedData = try Disk.retrieve(finalPath, from: .caches, as: [T].self)
            return storedData
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: id, error: error)
        }
    }
    
    public func getAll<T>(_ type: T.Type, completion: @escaping ([T]) -> Void) throws where T : PersistableType {
        
        let id = T.id()
        let finalPath = self.createPathFrom(type: type, id: id)
        
        do {
            let storedData = try Disk.retrieve(finalPath, from: .caches, as: [T].self)
            completion(storedData)
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: id, error: error)
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
        let id = type(of: item).id()
        let filePath = self.createPathFrom(type: T.self, id: id)
        let bool = Disk.exists(filePath, in: .caches)
        return bool
    }
    
    public func exists<T>(_ item: T!, completion: @escaping (Bool) -> Void) where T : PersistableType {
        let id = type(of: item).id()
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
    
    private func append<T>(_ item: T!) throws where T : PersistableType {
        
        let id = type(of: item).id()
        let finalPath = self.createPathFrom(type: T.self, id: id)
        
        do {
            try Disk.append(item, to: finalPath, in: .caches)
        } catch let error as NSError {
            throw error
        }
    }
    
    internal func createPathFrom<T>(type: T.Type, id: String?) -> String where T : PersistableType {
        let pathName: String = String(describing: type).lowercased()
        let id = id == nil ? "" : "/\(id!).json"
        let filePath: String = "\(self.prefix ?? "MZ")/\(pathName)\(id)"
        return filePath
    }
    

}

