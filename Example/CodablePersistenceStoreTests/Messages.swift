//
//  Messages.swift
//  CodablePersistenceStoreTests
//
//  Created by Mario Zimmermann on 17.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import CodablePersistenceStore

struct Message: PersistableType {
    
    let title: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
    }
    
   static func id() -> String {
        return "hey"
    }
    
    static func path() -> String {
        return "Yo"
    }
    
}

struct FailMessage: PersistableType {
    
    let title: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
    }
    
    static func id() -> String {
        return ".json.json.json"
    }
    
    static func path() -> String {
        return ".json.json.json"
    }
    
}

// Conforms to Equatable so we can compare messages (i.e. message1 == message2)
extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.title == rhs.title && lhs.body == rhs.body
    }
}
