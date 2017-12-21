//
//  Messages.swift
//  CodablePersistenceStoreTests
//
//  Created by Mario Zimmermann on 17.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import CodablePersistenceStore

class Message: PersistableType {


    let id: String
    let title: String
    let body: String
    
    init(id: String, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }
    
     func identifier() -> String {
        return self.id
    }
}

struct FailMessage: PersistableType {
    
    let title: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
    }
    
     func identifier() -> String {
        return "<~~~~~~>"
    }
    

    
}

// Conforms to Equatable so we can compare messages (i.e. message1 == message2)
extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.title == rhs.title && lhs.body == rhs.body
    }
}
