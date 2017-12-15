//
//  CanBeIdentified.swift
//  CodablePersistenceStore
//
//  Created by Mario Zimmermann on 17.11.17.
//

import Foundation

public protocol CanBeIdentifiedProtocol {
    static func id() -> String
}
