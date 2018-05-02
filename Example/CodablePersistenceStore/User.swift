//
//  User.swift
//  CodablePersistenceStore_Example
//
//  Created by Mario Zimmermann on 22.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import CodablePersistenceStore

struct User: CanBePersistedProtocol {
    
    var id: String
    var firstName: String
    var lastName: String
    
    init(id: String, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func identifier() -> String {
        return self.id
    }
    
}

struct News: CanBePersistedProtocol {
    var id: String
    var title: String
    var content: String
    var isRead: Bool
    
    init(id: String,
         title: String,
         content: String,
         isRead: Bool = false) {
        self.id = id
        self.title = title
        self.content = content
        self.isRead = isRead
    }
    
    func identifier() -> String {
        return self.id
    }
}
