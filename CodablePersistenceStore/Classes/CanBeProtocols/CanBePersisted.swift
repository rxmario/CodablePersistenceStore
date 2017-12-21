//
//  CanBePersisted.swift
//  CodablePersistenceStore
//
//  Created by Mario Zimmermann on 16.11.17.
//

import Foundation

public protocol CanBePersistedProtocol: CanBeIdentifiedProtocol, Codable {}

public extension CanBePersistedProtocol {
    static func ==(lhs:Self, rhs:Self) -> Bool {
        return lhs.identifier() == rhs.identifier()
    }
}
