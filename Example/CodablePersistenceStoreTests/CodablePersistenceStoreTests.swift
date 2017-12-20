//
//  CodablePersistenceStoreTests.swift
//  CodablePersistenceStoreTests
//
//  Created by Mario Zimmermann on 17.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CodablePersistenceStore
import Nimble

class CodablePersistenceStoreTests: XCTestCase {
    
    var persistenceStore: CodablePersistenceStore!
    
    override func setUp() {
        super.setUp()
        self.persistenceStore = CodablePersistenceStore()
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
            let element = Message(idz: "\(i)", title: "Message \(i)", body: "...")
            array.append(element)
        }
        return array
    }()
    
    // =============================================================================//
    //                             IS RESPONSABLE TESTS                             //
    // =============================================================================//
    
    func testIsResponsable() {
    
       let isResponsible = self.persistenceStore.isResponsible(for: messages[0])
    
        expect(isResponsible).to(beTrue())
        
        let isResponsibleType = self.persistenceStore.isResponsible(forType: Message.self)
        
        expect(isResponsibleType).to(beTrue())
        
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

        expect { try self.persistenceStore.persist(self.messages[0])}.toNot(throwError(errorType: CodablePersistenceStoreErrors.self))
        
        do {
            let data = try self.persistenceStore.get("hey", type: Message.self)
            
            expect(data?.body).to(match(messages[0].body), description: "Should match")
            expect(data?.title).to(match(messages[0].title), description: "Should match")
            
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
                expect(expectedMessage).to(equal(message))
                expect(message).to(beAKindOf(Message.self))
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

                expect(expectedMessage0).to(equal(msgs[0]))
                expect(expectedMessage1).to(equal(msgs[1]))
                expect(expectedMessage2).to(equal(msgs[2]))
                
                expect(msgs[0]).to(beAKindOf(Message.self))
                expect(msgs[1]).to(beAKindOf(Message.self))
                expect(msgs[2]).to(beAKindOf(Message.self))
                
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
            
            expect(messagez[0]).to(equal(expectedMessage0))
            expect(messagez[1]).to(equal(expectedMessage1))
            expect(messagez[2]).to(equal(expectedMessage2))
            
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
        expect(exists).to(beFalse())
        
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
        
        let isStillInStore = self.persistenceStore.exists(messageToDelete)
        expect(isStillInStore).to(beFalse())
    }
    
    func testDeleteWithItemOnlyAndCompletion() {
        
        let messageToDelete = messages[0]
        let exp = expectation(description: "Item deleted")
        
        XCTAssertNoThrow(try self.persistenceStore.persist(messageToDelete))
        
        do {
            try self.persistenceStore.delete(messageToDelete, completion: {
                let isStillInStore = self.persistenceStore.exists(messageToDelete)
                expect(isStillInStore).to(beFalse())
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
            let isStillInStore = self.persistenceStore.exists(messageToDelete)
            expect(isStillInStore).to(beFalse())
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
                let isStillInStore = self.persistenceStore.exists(messageToDelete)
                expect(isStillInStore).to(beFalse())
                exp.fulfill()
            })
        } catch let error as NSError {
            XCTFail(error.localizedDescription)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    // =============================================================================//
    //                             EXISTS TESTS                                     //
    // =============================================================================//
    
    func testExistWithItemProvided() {
        
        let item = messages[0]
        
        XCTAssertNoThrow(try self.persistenceStore.persist(item))
        
        let isThere = self.persistenceStore.exists(item)
        
        expect(isThere).to(beTrue())
        
    }
    
    func testExistsWithItemAndCompletion() {
        
        let item = messages[0]
        let exp = expectation(description: "Item is in store.")
        
        XCTAssertNoThrow(try self.persistenceStore.persist(item))
        
        self.persistenceStore.exists(item) { (isThere) in
            expect(isThere).to(beTrue())
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testExistsWithIdentifierAndType() {
        
        let item = messages[0]
        
        XCTAssertNoThrow(try self.persistenceStore.persist(item))
        
        let isThere = self.persistenceStore.exists("hey", type: Message.self)
        
        expect(isThere).to(beTrue())
        
    }
    
    func testExistsWithIdentifierAndTypeAndCompletion() {
        
        let item = messages[0]
        let exp = expectation(description: "Item is in store.")
        
        XCTAssertNoThrow(try self.persistenceStore.persist(item))
        
        self.persistenceStore.exists("hey", type: Message.self) { (isThere) in
            expect(isThere).to(beTrue())
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    // =============================================================================//
    //                             FILTER TESTS                                     //
    // =============================================================================//
    
    func testFilter() {
        
        let firstItem = Message(idz: "10", title: "yo", body: "yo")
        let secondItem = Message(idz: "11", title: "yoyo", body: "yoyoyo")
        
        XCTAssertNoThrow(try self.persistenceStore.persist(firstItem))
        XCTAssertNoThrow(try self.persistenceStore.persist(secondItem))
        
        do {
            let itemWithId10 = try self.persistenceStore.filter(Message.self, includeElement: { (item: Message) -> Bool in
                return item.idz == "10"
            }).first
            expect(itemWithId10).toNot(beNil())
        } catch let error as NSError {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testAsyncFilter() {
        
        let firstItem = Message(idz: "10", title: "yo", body: "yo")
        let secondItem = Message(idz: "11", title: "yoyo", body: "yoyoyo")
        
        XCTAssertNoThrow(try self.persistenceStore.persist(firstItem))
        XCTAssertNoThrow(try self.persistenceStore.persist(secondItem))
        
        do {
            try self.persistenceStore.filter(Message.self, includeElement: { (Item: Message) -> Bool in
                return Item.idz == "10"
            }, completion: { (items) in
                
                expect(items).toNot(beNil())
                expect(firstItem).to(equal(items[0]))
                
            })
        } catch let error as NSError {
            XCTFail(error.localizedDescription)
        }
        
    }

    // =============================================================================//
    //                             ERROR TESTS                                      //
    // =============================================================================//
    
    
    func testErrors() {
        
        //                              GET ERRORS                                      //
        //==============================================================================//
    
        expect { try self.persistenceStore.get("yoyo", type: Message.self) }.to(throwError(errorType: CodablePersistenceStoreErrors.self))
        expect { try self.persistenceStore.getAll(Message.self) }.to(throwError(errorType: CodablePersistenceStoreErrors.self))
        expect { try self.persistenceStore.get("yo", type: Message.self, completion: { (_) in }) }.to(throwError(errorType: CodablePersistenceStoreErrors.self))
        expect { try self.persistenceStore.getAll(Message.self, completion: { (_) in }) }.to(throwError(errorType: CodablePersistenceStoreErrors.self))
        
        //==============================================================================//

        
        //                              DELETE ERRORS                                   //
        //==============================================================================//

        expect { try self.persistenceStore.delete(self.messages[0]) }.to(throwError(errorType: CodablePersistenceStoreErrors.self))
        expect { try self.persistenceStore.delete("yo", type: Message.self) }.to(throwError(errorType: CodablePersistenceStoreErrors.self))
        expect { try self.persistenceStore.delete(self.messages[0], completion: {})}.to(throwError(errorType: CodablePersistenceStoreErrors.self))
        expect { try self.persistenceStore.delete("yo", type: Message.self, completion: {})}.to(throwError(errorType: CodablePersistenceStoreErrors.self))
        
        //                              FILTER ERRORS                                   //
        //==============================================================================//
        
        
        expect { try self.persistenceStore.filter(Message.self, includeElement: { (item: Message) -> Bool in return item.idz == "10" })}.to(throwError(errorType: CodablePersistenceStoreErrors.self))
        
        expect { try self.persistenceStore.filter(Message.self, includeElement: { (item: Message) -> Bool in return item.idz == "10" }, completion: { (_)  in })}.to(throwError(errorType: CodablePersistenceStoreErrors.self))
        
        
    }
}
