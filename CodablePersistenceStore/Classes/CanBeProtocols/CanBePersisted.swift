//
//  CanBePersisted.swift
//  CodablePersistenceStore
//
//  Created by Mario Zimmermann on 16.11.17.
//

import Foundation

public protocol CanBePersistedProtocol: CanBeIdentifiedProtocol {}

public extension CanBePersistedProtocol {
    static func ==(lhs:Self, rhs:Self) -> Bool {
        return (type(of: lhs).id() == type(of: rhs).id())
    }
}
