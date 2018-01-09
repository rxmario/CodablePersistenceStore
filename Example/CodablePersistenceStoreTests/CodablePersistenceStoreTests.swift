//
//  CodablePersistenceStoreTests.swift
//  CodablePersistenceStoreTests
//
//  Created by Mario Zimmermann on 17.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

@testable import CodablePersistenceStore

class CodablePersistenceStoreTests: XCTestCase {
    
    var persistenceStore: CodablePersistenceStore!
    
    override func setUp() {
        super.setUp()
        self.persistenceStore = CodablePersistenceStore()
    }
    
    override func tearDown() {
        do {
            self.persistenceStore = CodablePersistenceStore(rootName: "YourApplication")
            try self.persistenceStore.cacheClear()
        } catch {
            fatalError("smthin went wrong.")
        }
    }
    
    let messages: [Message] = {
        var array = [Message]()
        for i in 1...10 {
            let element = Message(id: "\(i)", title: "Message \(i)", body: "...")
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
        
        expect { try self.persistenceStore.persist(self.messages[0]) }.toNot(throwError(closure: { (error) in
            XCTFail(error.localizedDescription)
        }))

    }
    
    func testPersistWithThreeNormalEntrysAsync() {
        
        let expectedMessage0 = messages[0]
        let expectedMessage1 = messages[1]
        let expectedMessage2 = messages[2]
        
        expect { try self.persistenceStore.persist(expectedMessage0, completion: {}) }.toNot(throwError(closure: { (error) in
            XCTFail(error.localizedDescription)
        }))
        
        expect { try self.persistenceStore.persist(expectedMessage1, completion: {}) }.toNot(throwError(closure: { (error) in
            XCTFail(error.localizedDescription)
        }))
        
        expect { try self.persistenceStore.persist(expectedMessage2, completion: {}) }.toNot(throwError(closure: { (error) in
            XCTFail(error.localizedDescription)
        }))
    }
    
    func testPersistWithThreeObjectsFromTheSameType() {
        
        let expectedMessage0 = messages[0]
        let expectedMessage1 = messages[1]
        let expectedMessage2 = messages[2]
        
        expect { try self.persistenceStore.persist(expectedMessage0) }.toNot(throwError(closure: { (error) in
            XCTFail(error.localizedDescription)
        }))
        
        expect { try self.persistenceStore.persist(expectedMessage1) }.toNot(throwError(closure: { (error) in
            XCTFail(error.localizedDescription)
        }))
        
        expect { try self.persistenceStore.persist(expectedMessage2) }.toNot(throwError(closure: { (error) in
            XCTFail(error.localizedDescription)
        }))
    }
    
    // =============================================================================//
    //                             RETRIEVE TESTS                                   //
    // =============================================================================//
    
    func testRetrieveDataWithOneNormalEntry() {
        
        let exp = expectation(description: "item received")
        
        expect { try self.persistenceStore.persist(self.messages[0]) }.toNot(throwError())

        do {
            let data = try self.persistenceStore.get("1", type: Message.self)
            
            expect(data?.body).to(match(messages[0].body), description: "Should match")
            expect(data?.title).to(match(messages[0].title), description: "Should match")
            
            exp.fulfill()
        } catch let error as NSError {
            XCTFail(error.localizedDescription)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testRetrieveDataWithOneNormalEntryAndCompletion() {
        
        let expectedMessage = messages[0]
        
        expect { try self.persistenceStore.persist(expectedMessage) }.toNot(throwError(closure: { (error) in
            XCTFail(error.localizedDescription)
        }))
        
        expect { try self.persistenceStore.get("1", type: Message.self, completion: { (message) in
            
            expect(expectedMessage).to(equal(message))
            expect(message).to(beAKindOf(Message.self))
            
        })}.toNot(throwError(closure: { (error) in
            
            XCTFail(error.localizedDescription)
            
        }))
       
    }
    
    func testGetAllWithThreeNormalEntrysWithCompletion() {
        
        let expectedMessage0 = messages[0]
        let expectedMessage1 = messages[1]
        let expectedMessage2 = messages[2]
        
        expect { try self.persistenceStore.persist(expectedMessage0) }.toNot(throwError())
        expect { try self.persistenceStore.persist(expectedMessage1) }.toNot(throwError())
        expect { try self.persistenceStore.persist(expectedMessage2) }.toNot(throwError())

        expect { try self.persistenceStore.getAll(Message.self, completion: { (messages) in

            expect(expectedMessage0).to(equal(messages[1]))
            expect(expectedMessage1).to(equal(messages[2]))
            expect(expectedMessage2).to(equal(messages[0]))
            
            expect(messages[0]).to(beAKindOf(Message.self))
            expect(messages[1]).to(beAKindOf(Message.self))
            expect(messages[2]).to(beAKindOf(Message.self))
            
            })}.toNot(throwError(closure: { (error) in
                XCTFail(error.localizedDescription)
            }))
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
            
            expect(messagez[1]).to(equal(expectedMessage0))
            expect(messagez[2]).to(equal(expectedMessage1))
            expect(messagez[0]).to(equal(expectedMessage2))
            
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
        
        expect { try self.persistenceStore.persist(self.messages[0]) }.toNot(throwError(errorType: CodablePersistenceStoreErrors.self))
        
        expect { try self.persistenceStore.delete("1", type: Message.self, completion: {}) }.toNot(throwError(errorType: CodablePersistenceStoreErrors.self))
        
        let exists = self.persistenceStore.exists(messages[0])
        
        expect(exists).to(beFalse())
        
    }
    
    
    func testDeleteWithItemOnly() {
        
        let messageToDelete = messages[0]
        
        expect { try self.persistenceStore.persist(messageToDelete)}.toNot(throwError(errorType: CodablePersistenceStoreErrors.self))
        
        expect { try self.persistenceStore.delete(messageToDelete)}.toNot(throwError(closure: { (error) in
            XCTFail(error.localizedDescription)
        }))
        
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
            try self.persistenceStore.delete("1", type: Message.self)
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
            try self.persistenceStore.delete("1", type: Message.self, completion: {
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
        
        expect { try self.persistenceStore.persist(item) }.toNot(throwError())
        
        XCTAssertNoThrow(try self.persistenceStore.persist(item))
        
        let isThere = self.persistenceStore.exists(item)
        
        expect(isThere).to(beTrue())
        
    }
    
    func testExistsWithItemAndCompletion() {
        
        let item = messages[0]
        
        expect { try self.persistenceStore.persist(item) }.toNot(throwError())
        
        self.persistenceStore.exists(item, completion: { (isThere) in
            expect(isThere).to(beTrue())
        })
    }
    
    func testExistsWithIdentifierAndType() {
        
        let item = messages[0]
        
        expect { try self.persistenceStore.persist(item) }.toNot(throwError())
        
        let isThere = self.persistenceStore.exists("1", type: Message.self)
        
        expect(isThere).to(beTrue())
        
    }
    
    func testExistsWithIdentifierAndTypeAndCompletion() {
        
        let item = messages[0]
        let exp = expectation(description: "Item is in store.")
        
        XCTAssertNoThrow(try self.persistenceStore.persist(item))
        
        expect { try self.persistenceStore.persist(item) }.toNot(throwError())
        
        self.persistenceStore.exists("1", type: Message.self) { (isThere) in
            expect(isThere).to(beTrue())
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testSynchronousIfFolderExists() {
        let item0 = messages[0]
        let item1 = messages[1]
        let item2 = messages[2]
        
        expect { try self.persistenceStore.persist(item0) }.toNot(throwError())
        expect {  try self.persistenceStore.persist(item1) }.toNot(throwError())
        expect { try self.persistenceStore.persist(item2) }.toNot(throwError())
        
        let isThere = self.persistenceStore.exists(Message.self)
        expect(isThere).to(beTrue())
        
        
    }
    
    func testAsynchronousIfFolderExists() {
        
        let item0 = messages[0]
        let item1 = messages[1]
        let item2 = messages[2]
        
        expect { try self.persistenceStore.persist(item0) }.toNot(throwError())
        expect {  try self.persistenceStore.persist(item1) }.toNot(throwError())
        expect { try self.persistenceStore.persist(item2) }.toNot(throwError())
        
        self.persistenceStore.exists(Message.self) { (isThere) in
            expect(isThere).to(beTrue())
        }
    }
    
    // =============================================================================//
    //                             FILTER TESTS                                     //
    // =============================================================================//
    
    func testFilter() {
        
        let firstItem = Message(id: "10", title: "yo", body: "yo")
        let secondItem = Message(id: "11", title: "yoyo", body: "yoyoyo")
        
        expect { try self.persistenceStore.persist(firstItem) }.toNot(throwError())
        expect { try self.persistenceStore.persist(secondItem) }.toNot(throwError())
        
        do {
            let itemWithId10 = try self.persistenceStore.filter(Message.self, includeElement: { (item: Message) -> Bool in
                return item.id == "10"
            }).first
            expect(itemWithId10).toNot(beNil())
        } catch let error as NSError {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testAsyncFilter() {
        
        let firstItem = Message(id: "10", title: "yo", body: "yo")
        let secondItem = Message(id: "11", title: "yoyo", body: "yoyoyo")
        
        expect { try self.persistenceStore.persist(firstItem) }.toNot(throwError())
        expect { try self.persistenceStore.persist(secondItem) }.toNot(throwError())
        
        do {
            try self.persistenceStore.filter(Message.self, includeElement: { (item: Message) -> Bool in
                return item.id == "10"
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
        
        
        expect { try self.persistenceStore.filter(Message.self, includeElement: { (item: Message) -> Bool in return item.id == "10" })}.to(throwError(errorType: CodablePersistenceStoreErrors.self))
        
        expect { try self.persistenceStore.filter(Message.self, includeElement: { (item: Message) -> Bool in return item.id == "10" }, completion: { (_)  in })}.to(throwError(errorType: CodablePersistenceStoreErrors.self))
        

        

        
    }
    
    // =============================================================================//
    //                             PATH TESTS                                       //
    // =============================================================================//
    
    func testCreatePathWithId() {
        
        let path = self.persistenceStore.createPathFrom(type: Message.self, id: "yo")
        
        let utf8root = "xmari0".data(using: .utf8)
        let base64root = utf8root?.base64EncodedString()
        
        let utf8path = "message".data(using: .utf8)
        let base64path = utf8path?.base64EncodedString()
        
        let utf8id = "yo.json".data(using: .utf8)
        let base64id = utf8id?.base64EncodedString()
        
        let expectedPath: String = "\(base64root!)/\(base64path!)/\(base64id!)"
        
        expect(expectedPath).to(equal(path))
        
    }
    
    func testCreatePathWithoutId() {
        let path = self.persistenceStore.createPathFrom(type: Message.self, id: nil)
        
        let utf8root = "xmari0".data(using: .utf8)
        let base64root = utf8root?.base64EncodedString()
        
        let utf8path = "message".data(using: .utf8)
        let base64path = utf8path?.base64EncodedString()
        
        let expectedPath: String = "\(base64root!)/\(base64path!)"
        
        expect(expectedPath).to(equal(path))
    }
    
}
