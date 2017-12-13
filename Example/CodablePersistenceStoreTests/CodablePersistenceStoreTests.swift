//
//  CodablePersistenceStoreTests.swift
//  CodablePersistenceStoreTests
//
//  Created by Mario Zimmermann on 17.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CodablePersistenceStore

class CodablePersistenceStoreTests: XCTestCase {
    
    var decoder: JSONDecoder!
    var encoder: JSONEncoder!
    var persistenceStore: CodablePersistenceStore!
    
    override func setUp() {
        super.setUp()
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        self.persistenceStore = CodablePersistenceStore(prefix: "xmari0")
    }
    
    override func tearDown() {
        do {
            try self.persistenceStore.clear(directory: .documents)
            try self.persistenceStore.clear(directory: .caches)
            try self.persistenceStore.clear(directory: .applicationSupport)
            try self.persistenceStore.clear(directory: .temporary)
        } catch {
            fatalError("smthin went wrong.")
        }
    }
    
    let messages: [Message] = {
        var array = [Message]()
        for i in 1...10 {
            let element = Message(title: "Message \(i)", body: "...")
            array.append(element)
        }
        return array
    }()
    
    func testIsResponsable() {
    
       let isResponsible = self.persistenceStore.isResponsible(for: messages[0])
    
        XCTAssertTrue(isResponsible)
        
        let isResponsibleType = self.persistenceStore.isResponsible(forType: Message.self)
        
        XCTAssertTrue(isResponsibleType)
        
    }
    
    func testPersistWithOneNormalEntryWithoutCompletion() {
        
        let exp = expectation(description: "data arrived")
        
        do {
            XCTAssertNoThrow(try self.persistenceStore.persist(messages[0]))
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testPersistWithOneNormalEntryWithCompletion() {
        
        let exp = expectation(description: "data arrived")
        
        do {
            XCTAssertNoThrow(try self.persistenceStore.persist(messages[0], completion: {
                exp.fulfill()
            }))
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testRetrieveDataWithOneNormalEntry() {
        
        let exp = expectation(description: "data arrived")
        XCTAssertNoThrow(try self.persistenceStore.persist(messages[0]))
        
        do {
            let data = try self.persistenceStore.get("hey", type: Message.self)
            XCTAssertEqual(data?.body, messages[0].body)
            XCTAssertEqual(data?.title, messages[0].title)
            exp.fulfill()
        } catch let error as NSError {
            XCTFail(error.localizedDescription)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
   func testRetrieveDataWithWrongId() {
    
    let exp = expectation(description: "error retrieved")
    XCTAssertNoThrow(try self.persistenceStore.persist(messages[0]))
    
    do {
        _ = try self.persistenceStore.get("yyy", type: Message.self)
    } catch let error as NSError {
        XCTAssertNotNil(error, "got it")
        exp.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    
    }
    
    func testDeleteWithOneNormalEntry() throws {
        
        let exp = expectation(description: "Item deleted")
        
        try self.persistenceStore.persist(messages[0])
        
        try self.persistenceStore.delete(messages[0].id(), type: Message.self, completion: {
            exp.fulfill()
        })
        
        let exists = try self.persistenceStore.exists(messages[0])
        XCTAssertFalse(exists)
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testGetAllWithThreeNormalEntrys() {
        
        let expectedMessage0 = messages[0]
        let expectedMessage1 = messages[1]
        let expectedMessage2 = messages[2]
        
        let exp = expectation(description: "Received data")

        XCTAssertNoThrow(try self.persistenceStore.persist(expectedMessage0))

        //XCTAssertNoThrow(try self.persistenceStore.persist(messages[2]))
        
            do {
                try self.persistenceStore.getAll(Message.self, completion: { (msgs) in
                    XCTAssertNotNil(msgs)
                    exp.fulfill()
                })
            } catch let e as NSError {
                XCTFail(e.localizedDescription)
        }
        
        
        waitForExpectations(timeout: 10, handler: nil)

    }
}
