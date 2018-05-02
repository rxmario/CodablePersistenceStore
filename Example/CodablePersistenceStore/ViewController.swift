//
//  ViewController.swift
//  CodablePersistenceStore
//
//  Created by Mario Zimmermann on 11/16/2017.
//  Copyright (c) 2017 Mario Zimmermann. All rights reserved.
//

import UIKit
import CodablePersistenceStore

class ViewController: UIViewController {
    
    // @IBOutlets
    @IBOutlet weak var userOneLabel: UILabel!
    
    @IBOutlet weak var userTwoLabel: UILabel!
    
    @IBOutlet weak var persistButton: UIButton!
    
    @IBAction func persistButtonTapped(_ sender: Any) {
        persist()
    }
    
    let store = CodablePersistenceStore(rootName: "xmari0", version: 4) { (currentStore, newVersion, oldVersion) in
        
        print("Version changed from version: \(oldVersion) to version: \(newVersion)")
        try! currentStore.cacheClear()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPersistedUsers()
        updateExample()
        
        
        
    }
    
    func persist() {
        
        let user0 = User(id: "1", firstName: "Mario", lastName: "Zimmermann")
        let user1 = User(id: "2", firstName: "Jan", lastName: "Bartel")
        
        do {
            try self.store.persist(user0, completion: {
                print("User: \(user0.firstName) is now in the store. 🎉")
            })
            try self.store.persist(user1, completion: {
                print("User: \(user1.firstName) is now in the store. 🎉")
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    func getPersistedUsers() {
        
        if store.exists("1", type: User.self) && store.exists("2", type: User.self) {
            do {
                let users = try self.store.getAll(User.self)
                
                self.userOneLabel.text = "\(users[0].firstName) \(users[0].lastName)"
                self.userTwoLabel.text = "\(users[1].firstName) \(users[1].lastName)"
                
                
                self.persistButton.isHidden = true
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            return
        }
    }
    
    func updateExample() {
        
        var news = News(id: "001", title: "Hey", content: "Hello World", isRead: false)
        
        try! self.store.persist(news)
        
        let storedNews = try! self.store.getAll(News.self)
        
        print(storedNews[0])
        
        print("Starting update")
        
        news.isRead = true
        
        try! self.store.update(news)
        
        let updatedNews = try! self.store.getAll(News.self)
        
        print(updatedNews[0])
        
        print(updatedNews)
        
    }
}



