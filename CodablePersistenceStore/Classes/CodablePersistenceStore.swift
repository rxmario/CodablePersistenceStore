//
//  CodablePersistenceStore.swift
//  CodablePersistenceStore
//
//  Created by Mario Zimmermann on 16.11.17.
//

import Foundation
import Disk

public typealias PersistableType = CanBePersistedProtocol
public typealias NewVersion = Int
public typealias OldVersion = Int

open class CodablePersistenceStore: CodablePersistenceStoreProtocol {
    
    /// The name of the rootfolder on the device.
    var rootName: String?
    
    /// Creates a default root folder.
    public init() {}
    
    /// Use this initializer if you want to create your own root folder.
    ///
    /// - Parameter rootName: The name of your root folder.
    public init(rootName: String?){
        self.rootName = rootName
    }
    
    /// Use this constructor in order to be able to flush the store when the version changes.
    /// You might want to flush the persisted data to prevent crashes when models change.
    ///
    /// - Parameters:
    ///   - rootName: The name of the root folder.
    ///   - version: the version of the store
    ///   - changeVersionHandler: A closure containing the store, the new version and the old version.
    public convenience init(rootName: String? = "xmari0", version: Int = 0, changeVersionHandler:@escaping ((CodablePersistenceStore, NewVersion, OldVersion) -> Void) ){
        self.init(rootName: rootName)
        
        let dbVersionKey = "CodablePersistenceStoreVersion"
        
        let oldVersion = UserDefaults.standard.integer(forKey: dbVersionKey)
        
        if oldVersion != version {
            
            UserDefaults.standard.set(version, forKey: dbVersionKey)
            
            changeVersionHandler(self, version, oldVersion)
        }
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
        
        do {
            try Disk.save(item, to: .applicationSupport, as: filePath)
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
            try Disk.save(item, to: .applicationSupport, as: filePath)
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
            try Disk.remove(filePath, from: .applicationSupport)
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
            try Disk.remove(filePath, from: .applicationSupport)
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
            try Disk.remove(filePath, from: .applicationSupport)
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: identifier, error: error)
        }
    }
    
    /// Use this method to delete an item asynchronously.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of your item.
    ///   - type: Persistable Type
    ///   - completion: Just a closure to do things afterwards.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func delete<T>(_ identifier: String, type: T.Type, completion: @escaping () -> ()) throws where T : PersistableType {
        
        let filePath = self.createPathFrom(type: type, id: identifier)
        
        do {
            try Disk.remove(filePath, from: .applicationSupport)
            completion()
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: identifier, error: error)
        }
    }
    
    /// Use this method to update an item.
    ///
    /// - Parameter newItem: the changed item.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func update<T>(_ newItem: T!) throws where T : PersistableType {
        
        let filePath = self.createPathFrom(type: T.self, id: newItem.identifier())
        
        do {
            try Disk.save(newItem, to: .applicationSupport, as: filePath)
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CannotFindItemsFor(type: T.self, error: error)
        }
    }
    
    /// Use this method to update an item asynchronously
    ///
    /// - Parameters:
    ///   - newItem: the changed item.
    ///   - completion: Just a closure to do things afterwards.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func update<T>(_ newItem: T!, completion: @escaping () -> ()) throws where T : CanBePersistedProtocol {
        
        let filePath = self.createPathFrom(type: T.self, id: newItem.identifier())
        
        do {
            try Disk.save(newItem, to: .applicationSupport, as: filePath)
            completion()
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CannotFindItemsFor(type: T.self, error: error)
        }
    }
    
    /// Use this method to retrieve an item by its identifier.
    ///
    /// - Parameters:
    ///   - identifier: The id of your item.
    ///   - type: The item's type.
    ///   - Returns: Your item.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func get<T>(_ identifier: String, type: T.Type) throws -> T? where T : PersistableType {
        
        let finalPath = self.createPathFrom(type: type, id: identifier)
        
        do {
            let unarchivedData = try Disk.retrieve(finalPath, from: .applicationSupport, as: type.self)
            return unarchivedData
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: identifier, error: error)
        }
    }
    
    /// Use this method to retrieve an item by its identifier asynchronous.
    ///
    /// - Parameters:
    ///   - identifier: The id of your item.
    ///   - type: The item's type
    ///   - completion: Your item.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func get<T>(_ identifier: String, type: T.Type, completion: @escaping (T?) -> Void) throws where T : PersistableType {
        
        let filePath = self.createPathFrom(type: type, id: identifier)
        
        do {
            let storedData = try Disk.retrieve(filePath, from: .applicationSupport, as: type.self)
            completion(storedData)
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CouldntFindItemForId(id: identifier, error: error)
        }
    }
    
    /// Use this method to get all objects from a certain type.
    ///
    /// - Parameter type: The type of your desired items.
    /// - Returns: An Array of objects from your desired type.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func getAll<T>(_ type: T.Type) throws -> [T] where T : PersistableType {
        
        let finalPath = self.createPathFrom(type: type, id: nil)
        let jsonDecoder = JSONDecoder()
        
        var _decodedJSON: [T] = [T]()
        
        do {
            let storedData = try Disk.retrieve(finalPath, from: .applicationSupport, as: [Data].self)
            
            for item in storedData {
                let obj = try! jsonDecoder.decode(T.self, from: item)
                _decodedJSON.append(obj)
            }
            return _decodedJSON
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CannotFindItemsFor(type: type, error: error)
        }
    }
    
    /// Use this method to get all objects from a certain type asynchronous.
    ///
    /// - Parameters:
    ///   - type: The type of your desired items.
    ///   - completion: An Array of objects from your desired type.
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func getAll<T>(_ type: T.Type, completion: @escaping ([T]) -> Void) throws where T : PersistableType {
        
        let finalPath = self.createPathFrom(type: type, id: nil)
        let jsonDecoder = JSONDecoder()
        
        var _decodedJSON: [T] = [T]()
        
        do {
            let storedData = try Disk.retrieve(finalPath, from: .applicationSupport, as: [Data].self)
            
            for item in storedData {
                let obj = try! jsonDecoder.decode(T.self, from: item)
                print(obj.identifier())
                _decodedJSON.append(obj)
            }
            completion(_decodedJSON)
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CannotFindItemsFor(type: type, error: error)
        }
    }
    
    /// Use this method to get all items with a certain condition (e.g. item.isRead == true)
    ///
    /// - Parameters:
    ///   - type: The type of your items.
    ///   - includeElement: The item you'd like to filter
    /// - Returns: An array with filtered objects
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func filter<T>(_ type: T.Type, includeElement: @escaping (T) -> Bool) throws -> [T] where T : PersistableType {
        
        do {
            let storedData = try self.getAll(type)
            let filtered = storedData.filter(includeElement)
            return filtered
        } catch {
            throw CodablePersistenceStoreErrors.CannotUseType(type: T.Type.self, inStoreWithType: PersistableType.Type.self)
        }
    }
    
    /// Use this method to get all items with a certain condition asynchronous (e.g. item.isRead == true)
    ///
    /// - Parameters:
    ///   - type: The type of your items.
    ///   - includeElement: The item you'Äd like to filter.
    ///   - completion: An array with filtered objects
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func filter<T>(_ type: T.Type, includeElement: @escaping (T) -> Bool, completion: @escaping ([T]) -> Void) throws where T : PersistableType {
        
        do {
            let storedData = try self.getAll(type)
            let filtered = storedData.filter(includeElement)
            completion(filtered)
        } catch {
            throw CodablePersistenceStoreErrors.CannotUseType(type: T.Type.self, inStoreWithType: PersistableType.Type.self)
        }
    }
    
    /// Use this method to check if an item is already in the store.
    ///
    /// - Parameter item: Your item.
    /// - Returns: Boolean
    public func exists<T>(_ item: T) -> Bool where T : PersistableType {
        let id = item.identifier()
        let filePath = self.createPathFrom(type: T.self, id: id)
        let bool = Disk.exists(filePath, in: .applicationSupport)
        return bool
    }
    
    /// Use this method to check if an item is already in the store asynchronous.
    ///
    /// - Parameters:
    ///   - item: Your item.
    ///   - completion: Boolean
    public func exists<T>(_ item: T!, completion: @escaping (Bool) -> Void) where T : PersistableType {
        let id = item.identifier()
        let filePath = self.createPathFrom(type: T.self, id: id)
        let bool = Disk.exists(filePath, in: .applicationSupport)
        completion(bool)
    }
    
    /// Use this method to check if an item exists by identifier and type.
    ///
    /// - Parameters:
    ///   - identifier: The item's id
    ///   - type: The item's type
    /// - Returns: Boolean
    public func exists<T>(_ identifier: String, type: T.Type) -> Bool where T : PersistableType {
        let filePath = self.createPathFrom(type: type, id: identifier)
        let bool = Disk.exists(filePath, in: .applicationSupport)
        return bool
    }
    
    /// Use this method to check if an item exists already in the store asynchronous.
    ///
    /// - Parameters:
    ///   - identifier: The item's id
    ///   - type: The item's type
    ///   - completion: Boolean
    public func exists<T>(_ identifier: String, type: T.Type, completion: @escaping (Bool) -> Void) where T : PersistableType {
        let filePath = self.createPathFrom(type: type, id: identifier)
        let bool = Disk.exists(filePath, in: .applicationSupport)
        completion(bool)
    }
    
    /// Use this method to check synchronous if a collection of a special type already exists in the store.
    ///
    /// - Parameter type: The type you'd like to check.
    /// - Returns: Boolean
    public func exists<T>(_ type: T.Type) -> Bool where T : CanBePersistedProtocol {
        let filePath = self.createPathFrom(type: type, id: nil)
        let bool = Disk.exists(filePath, in: .applicationSupport)
        return bool
    }
    
    /// Use this method to check asynchronous if a collection of a special type already exists in the store.
    ///
    /// - Parameters:
    ///   - type: The type you'd like to check.
    ///   - completion: Boolean
    public func exists<T>(_ type: T.Type, completion: @escaping (Bool) -> Void) where T : CanBePersistedProtocol {
        let filePath = self.createPathFrom(type: type, id: nil)
        let bool = Disk.exists(filePath, in: .applicationSupport)
        completion(bool)
    }
    
    /// Use this method to clear the whole cache.
    ///
    /// - Throws: An Error containing the localized description, localized failure reason and localized suggestions.
    public func cacheClear() throws {
        do {
            try Disk.clear(.applicationSupport)
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CouldntClearCache(error: error)
        }
    }
    
    internal func createPathFrom<T>(type: T.Type, id: String?) -> String where T : PersistableType {
        
        let pathName: String = String(describing: type).lowercased()
        let slash: String = id == nil ? "" : "/"
        let id: String = id == nil ? "" : "\(id!).json"
        let rootName: String? = self.rootName == nil ? "xmari0" : self.rootName
        
        let utf8root: Data? = rootName?.data(using: .utf8)
        let utf8id: Data? = id.data(using: .utf8)
        let utf8path: Data? = pathName.data(using: .utf8)
        
        let base64root: String? = utf8root?.base64EncodedString()
        let base64id: String? = utf8id?.base64EncodedString()
        let base64path: String? = utf8path?.base64EncodedString()
        
        let base64filePath: String = "\(base64root!)/\(base64path!)\(slash)\(base64id!)"
        
        return base64filePath
    }
}
