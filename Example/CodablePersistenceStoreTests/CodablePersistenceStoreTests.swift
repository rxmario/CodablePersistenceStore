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
    
    var persistenceStore: CodablePersistenceStore!
    
    override func setUp() {
        super.setUp()
        self.persistenceStore = CodablePersistenceStore(prefix: "xmari0")
    }
    
    override func tearDown() {
        do {
            try self.persistenceStore.cacheClear()
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
    
    // =============================================================================//
    //                             IS RESPONSABLE TESTS                             //
    // =============================================================================//
    
    func testIsResponsable() {
    
       let isResponsible = self.persistenceStore.isResponsible(for: messages[0])
    
        XCTAssertTrue(isResponsible)
        
        let isResponsibleType = self.persistenceStore.isResponsible(forType: Message.self)
        
        XCTAssertTrue(isResponsibleType)
        
    }
    
    // =============================================================================//
    //                             PERSISTENCE TESTS                                //
    // =============================================================================//
    
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
    
    func testPersistWithThreeObjectsFromTheSameType() {
        
        let expectedMessage0 = messages[0]
        let expectedMessage1 = messages[1]
        
        let exp = expectation(description: "stored data")
        
        XCTAssertNoThrow(try self.persistenceStore.persist(expectedMessage0))
        XCTAssertNoThrow(try self.persistenceStore.persist(expectedMessage1, completion: {
            exp.fulfill()
        }))

        waitForExpectations(timeout: 5, handler: nil)
    
    }
    
    // =============================================================================//
    //                             RETRIEVE TESTS                                   //
    // =============================================================================//
    
    func testRetrieveDataWithOneNormalEntry() {
        
        let exp = expectation(description: "item received")
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
    
    func testRetrieveDataWithOneNormalEntryAndCompletion() {
        
        let exp = expectation(description: "item received")
        let expectedMessage = messages[0]
        
        XCTAssertNoThrow(try self.persistenceStore.persist(expectedMessage))
        
        do {
            try self.persistenceStore.get("hey", type: Message.self, completion: { (message) in
                XCTAssertEqual(expectedMessage, message, "Should be equal")
                exp.fulfill()
            })
        } catch let error as NSError {
            XCTFail(error.localizedDescription)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testGetAllWithThreeNormalEntrysWithCompletion() {
        
        let expectedMessage0 = messages[0]
        let expectedMessage1 = messages[1]
        let expectedMessage2 = messages[2]
        
        let exp = expectation(description: "Received data")
        
        XCTAssertNoThrow(try self.persistenceStore.persist(expectedMessage0))
        XCTAssertNoThrow(try self.persistenceStore.persist(expectedMessage1))
        XCTAssertNoThrow(try self.persistenceStore.persist(expectedMessage2))
        
        do {
            try self.persistenceStore.getAll(Message.self, completion: { (msgs) in
                XCTAssertEqual(msgs[0], expectedMessage0)
                exp.fulfill()
            })
        } catch let e as NSError {
            XCTFail(e.localizedDescription)
        }
        
        
        waitForExpectations(timeout: 10, handler: nil)
        
    }
    
    func testGetAllWithThreeNormalEntrysWithoutCompletion() {
        
        let expectedMessage0 = messages[0]
        let expectedMessage1 = messages[1]
        let expectedMessage2 = messages[2]
        
        let exp0 = expectation(description: "data persisted")
        let exp1 = expectation(description: "data received")
        do {
            try self.persistenceStore.persist(expectedMessage0)
            try self.persistenceStore.persist(expectedMessage1)
            try self.persistenceStore.persist(expectedMessage2)
            exp0.fulfill()
        } catch let error as NSError {
            XCTFail(error.localizedDescription)
        }
        
        do {
            let messagez = try self.persistenceStore.getAll(Message.self)
            XCTAssertEqual(messagez[0], expectedMessage0)
            XCTAssertEqual(messagez[1], expectedMessage1)
            XCTAssertEqual(messagez[2], expectedMessage2)
            exp1.fulfill()
        } catch let error as NSError {
            XCTFail(error.localizedDescription)
        }
        
        
        waitForExpectations(timeout: 10 , handler: nil)
    }
    
    // =============================================================================//
    //                             DELETE TESTS                                     //
    // =============================================================================//
    
    
    func testDeleteWithOneNormalEntry() throws {
        
        let exp = expectation(description: "Item deleted")
        
        try self.persistenceStore.persist(messages[0])
        
        try self.persistenceStore.delete("hey", type: Message.self, completion: {
            exp.fulfill()
        })
        
        let exists = self.persistenceStore.exists(messages[0])
        XCTAssertFalse(exists)
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    
    func testDeleteWithItemOnly() {
        
        let messageToDelete = messages[0]
        
        XCTAssertNoThrow(try self.persistenceStore.persist(messageToDelete))
        
        do {
            try self.persistenceStore.delete(messageToDelete)
        } catch let error as NSError {
            XCTFail(error.localizedDescription)
        }
        
        let isDeleted = self.persistenceStore.exists(messageToDelete)
        XCTAssertFalse(isDeleted)
    }
    
    func testDeleteWithItemOnlyAndCompletion() {
        
        let messageToDelete = messages[0]
        let exp = expectation(description: "Item deleted")
        
        XCTAssertNoThrow(try self.persistenceStore.persist(messageToDelete))
        
        do {
            try self.persistenceStore.delete(messageToDelete, completion: {
                let isDeleted = self.persistenceStore.exists(messageToDelete)
                XCTAssertFalse(isDeleted)
                exp.fulfill()
            })
        } catch let error as NSError {
            XCTFail(error.localizedDescription)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testDeleteWithIdentifierAndTypeOnly() {
        
        let messageToDelete = messages[0]
        
        XCTAssertNoThrow(try self.persistenceStore.persist(messageToDelete))
        
        do {
            try self.persistenceStore.delete("hey", type: Message.self)
            let isDeleted = self.persistenceStore.exists(messageToDelete)
            XCTAssertFalse(isDeleted)
        } catch let error as NSError {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDeleteWithIdentifierAndTypeAndCompletion() {
        
        let messageToDelete = messages[0]
        let exp = expectation(description: "Item deleted")
        
        XCTAssertNoThrow(try self.persistenceStore.persist(messageToDelete))
        
        do {
            try self.persistenceStore.delete("hey", type: Message.self, completion: {
                let isDeleted = self.persistenceStore.exists(messageToDelete)
                XCTAssertFalse(isDeleted)
                exp.fulfill()
            })
        } catch let error as NSError {
            XCTFail(error.localizedDescription)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    // =============================================================================//
    //                             ERROR TESTS                                      //
    // =============================================================================//
    
    
    func testErrors() {
        
        //                              GET ERRORS                                      //
        //==============================================================================//
        
        XCTAssertThrowsError(try self.persistenceStore.get("yoyo", type: Message.self))
        XCTAssertThrowsError(try self.persistenceStore.getAll(Message.self))
        XCTAssertThrowsError(try self.persistenceStore.get("id", type: Message.self, completion: { (msg) in XCTAssertNil(msg) }))
        XCTAssertThrowsError(try self.persistenceStore.getAll(Message.self, completion: { (msgs) in XCTAssertNil(msgs) }))
        
        //==============================================================================//

        
        //                              DELETE ERRORS                                   //
        //==============================================================================//

        XCTAssertThrowsError(try self.persistenceStore.delete(messages[0]))
        XCTAssertThrowsError(try self.persistenceStore.delete("yo", type: Message.self))
        XCTAssertThrowsError(try self.persistenceStore.delete(messages[0], completion: {}))
        XCTAssertThrowsError(try self.persistenceStore.delete("yo", type: Message.self, completion: {}))
        
        
        //                              CACHE CLEAR ERROR                               //
        //==============================================================================//
        
    }
}
