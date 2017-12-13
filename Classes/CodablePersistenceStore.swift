//
//  CodablePersistenceStore.swift
//  CodablePersistenceStore
//
//  Created by Mario Zimmermann on 16.11.17.
//

import Foundation
import Disk

open class CodablePersistenceStore: CodablePersistenceStoreProtocol {
    
    
    public typealias CanBePersisted = Codable & CanBePersistedProtocol
    public typealias PersistableType = CanBePersisted

    
    var encoder: JSONEncoder!
    var decoder: JSONDecoder!
    
    public init(encoder: JSONEncoder, decoder: JSONDecoder){
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func persist<T>(_ item: T!) throws where T : PersistableType {
        do {
            let data = try self.encoder.encode(item)
            try Disk.save(data, to: .caches, as: self.createPrefix())
        } catch let error as NSError {
            fatalError(self.printDescribingError(error: error))
        }
    }
    
    func persist<T>(_ item: T!, completion: @escaping () -> ()) throws where T : PersistableType {
        do {
            let data = try self.encoder.encode(item)
            try Disk.save(data, to: .caches, as: self.createPrefix())
            completion()
        } catch let error as NSError {
            fatalError(self.printDescribingError(error: error))
        }
    }
    
     func delete<T>(_ item: T!) throws where T : PersistableType {
        do {
            let id = item.id()
            let path = type(of: item).path()
            let file = path + id
            try Disk.remove(file, from: .caches)
        } catch let error as NSError {
            fatalError(self.printDescribingError(error: error))
        }
    }
    
    func delete<T>(_ item: T!, completion: @escaping () -> ()) throws where T : PersistableType {
        do {
            let id = item.id()
            let path = type(of: item).path()
            let file = path + id
            try Disk.remove(file, from: .caches)
            completion()
        } catch let error as NSError {
            fatalError(self.printDescribingError(error: error))
        }
    }
    
    func delete<T>(_ identifier: String, type: T.Type) throws where T : PersistableType {
        do {
            let path = type.path()
            let file = path + identifier
            try Disk.remove(file, from: .caches)
        } catch let error as NSError {
            fatalError(self.printDescribingError(error: error))
        }
    }
    
    func delete<T>(_ identifier: String, type: T.Type, completion: @escaping () -> ()) throws where T : PersistableType {
        do {
            let path = type.path()
            let file = path + identifier
            try Disk.remove(file, from: .caches)
            completion()
        } catch let error as NSError {
            fatalError(self.printDescribingError(error: error))
        }
    }
    
    func get<T>(_ identifier: String) throws -> T? where T : CanBePersisted {
        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
    }
    
    func get<T>(_ identifier: String, type: T.Type) throws -> T? where T : PersistableType {
        do {
            let path = type.path()
            let file = path + identifier
            let storedData = try Disk.retrieve(file, from: .caches, as: type)
            let data = try self.decoder.decode(type.self, from: storedData as! Data)
            return data
        } catch let error as NSError {
            fatalError(self.printDescribingError(error: error))
        }
    }
    
    func get<T>(_ identifier: String, completion: @escaping (T?) -> Void) throws where T : PersistableType {
        throw CodablePersistenceStoreErrors.MethodHasToBeImplemented
    }
    
    func get<T>(_ identifier: String, type: T.Type, completion: @escaping (T?) -> Void) throws where T : PersistableType {
        do {
            let path = type.path()
            let filePath = path + identifier
            let storedData = try Disk.retrieve(filePath, from: .caches, as: type)
            let data = try self.decoder.decode(type.self, from: storedData as! Data)
            completion(data)
        } catch let error as NSError {
            fatalError(self.printDescribingError(error: error))
        }
    }
    
    public func clear(directory: Disk.Directory) throws {
        do {
            try Disk.clear(directory)
        } catch let error as NSError {
            fatalError(self.printDescribingError(error: error))
        }
    }
    
    private func createPrefix() -> String {
        let prefix = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        return "\(prefix)/"
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

