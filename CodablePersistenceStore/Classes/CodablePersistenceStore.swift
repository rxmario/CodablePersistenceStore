//
//  CodablePersistenceStore.swift
//  CodablePersistenceStore
//
//  Created by Mario Zimmermann on 16.11.17.
//

import Foundation
import Disk

public typealias PersistableType = Codable & CanBePersistedProtocol

open class CodablePersistenceStore: CodablePersistenceStoreProtocol {

    var prefix: String!
    
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
        
        let path = type(of: item).path()
        let id = type(of: item).id()
        let filePath = self.createPath(path: path, id: id)
        print(filePath)
        
        do {
            try Disk.save(item, to: .caches, as: filePath)
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(item)
            print(String(data: encoded, encoding: .utf8)!)
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CannotUseProvidedItem(item: item, error: error)
        }
    }
    
    public func persist<T>(_ item: T!, completion: @escaping () -> ()) throws where T : PersistableType {
        
        let path = type(of: item).path()
        let id = type(of: item).id()
        let finalPath = self.createPath(path: path, id: id)
        
        do {
            try Disk.save(item, to: .caches, as: finalPath)
            completion()
        } catch let error as NSError {
            throw CodablePersistenceStoreErrors.CannotUseProvidedItem(item: item, error: error)
        }
    }
    
    public func append<T>(_ item: T!) throws where T : PersistableType {
        
        let path = type(of: item).path()
        let id = type(of: item).id()
        let finalPath = self.createPath(path: path, id: id)
        
        do {
            try Disk.append(item, to: finalPath, in: .caches)
        } catch let error as NSError {
            throw error
        }
        
    }
    
    public func append<T>(_ item: T!, completion: @escaping () -> ()) throws where T : PersistableType {
        
        let path = type(of: item).path()
        let id = type(of: item).id()
        let finalPath = self.createPath(path: path, id: id)
        
        do {
            try Disk.append(item, to: finalPath, in: .caches)
            completion()
        } catch let error as NSError {
            throw error
        }
        
    }
    
    public func delete<T>(_ item: T!) throws where T : PersistableType {
        
        let id = type(of: item).id()
        let path = type(of: item).path()
        let filePath = self.createPath(path: path, id: id)
        
        do {
            try Disk.remove(filePath, from: .caches)
        } catch let error as NSError {
            fatalError(self.printDescribingError(error: error))
        }
    }
    
    public func delete<T>(_ item: T!, completion: @escaping () -> ()) throws where T : PersistableType {
        
        let id = type(of: item).id()
        let path = type(of: item).path()
        let filePath = self.createPath(path: path, id: id)
        
        do {
            try Disk.remove(filePath, from: .caches)
            completion()
        } catch let error as NSError {
            fatalError(self.printDescribingError(error: error))
        }
    }
    
    public func delete<T>(_ identifier: String, type: T.Type) throws where T : PersistableType {
        
        let path = type.path()
        let filePath = self.createPath(path: path, id: identifier)
        
        do {
            try Disk.remove(filePath, from: .caches)
        } catch let error as NSError {
            fatalError(self.printDescribingError(error: error))
        }
    }
    
    public func delete<T>(_ identifier: String, type: T.Type, completion: @escaping () -> ()) throws where T : PersistableType {
        
        let path = type.path()
        let filePath = self.createPath(path: path, id: identifier)
        
        do {
            try Disk.remove(filePath, from: .caches)
            completion()
        } catch let error as NSError {
            throw error
        }
    }
    
    public func get<T>(_ identifier: String, type: T.Type) throws -> T? where T : PersistableType {
        
        let path = type.path()
        let finalPath = self.createPath(path: path, id: identifier)
        
        do {
            let unarchivedData = try Disk.retrieve(finalPath, from: .caches, as: type.self)
            return unarchivedData
        } catch let error as NSError {
           throw error
        }
    }
    
    public func get<T>(_ identifier: String, type: T.Type, completion: @escaping (T?) -> Void) throws where T : PersistableType {
        do {
            let filePath = self.createPath(path: type.path(), id: nil)
            let storedData = try Disk.retrieve(filePath, from: .caches, as: type.self)
            completion(storedData)
        } catch let error as NSError {
            fatalError(self.printDescribingError(error: error))
        }
    }
    
    
    
    public func getAll<T>(_ type: T.Type) throws -> [T] where T : PersistableType {
        
        let path = T.path()
        let id = T.id()
        let finalPath = self.createPath(path: path, id: id)
        
        do {
            let storedData = try Disk.retrieve(finalPath, from: .caches, as: [T].self)
            return storedData
        } catch let error as NSError {
            throw error
        }
    }
    
    public func getAll<T>(_ type: T.Type, completion: @escaping ([T]) -> Void) throws where T : PersistableType {
        
        let path = T.path()
        let id = T.id()
        let finalPath = self.createPath(path: path, id: id)
        
        do {
            let storedData = try Disk.retrieve(finalPath, from: .caches, as: [T].self)
            completion(storedData)
        } catch let error as NSError {
            throw error
        }
    }
    
    public func exists(_ item: PersistableType!) -> Bool {
        let id = type(of: item).id()
        let path = type(of: item).path()
        let filePath = self.createPath(path: path, id: id)
        let bool = Disk.exists(filePath, in: .caches)
        return bool
    }
    
    public func cacheClear() throws {
        do {
            try Disk.clear(.caches)
        } catch let error as NSError {
            fatalError(self.printDescribingError(error: error))
        }
    }
    
    private func createPath(path: String, id: String?) -> String {
        let id = id == nil ? "" : "/\(id!).json"
        let filePath: String = "\(self.prefix ?? "MZ")/\(path)\(id)"
        return filePath
    }
    
    private func printDescribingError(error: NSError) -> String {
        return """
        Domain: \(error.domain)
        Code: \(error.code)
        Description: \(error.localizedDescription)
        Failure Reason: \(error.localizedFailureReason ?? "No failure reason detected.")
        Suggestions: \(error.localizedRecoverySuggestion ?? "No suggestions available.")
        """
    }
}

