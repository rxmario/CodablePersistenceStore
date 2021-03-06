//
//  CodablePersistenceStoreErrors.swift
//  CodablePersistenceStore
//
//  Created by Mario Zimmermann on 16.11.17.
//

import Foundation

public enum CodablePersistenceStoreErrors: Error {
    case CannotUseProvidedItem(item: Any, includedError: NSError)
    case CannotFindItemsFor(type: Any.Type, error: NSError)
    case CannotUse(object : Any, inStoreWithType: Any.Type)
    case CannotUseType(type : Any.Type, inStoreWithType: Any.Type)
    case MethodHasToBeImplemented
    case noValidPathProvided
    case CouldntFindItemForId(id: String, error: NSError)
    case CouldntClearCache(error: NSError)
}
