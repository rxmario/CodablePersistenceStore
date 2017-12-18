# CodablePersistenceStore

[![CI Status](http://img.shields.io/travis/Mario Zimmermann/CodablePersistenceStore.svg?style=flat)](https://travis-ci.org/Mario Zimmermann/CodablePersistenceStore)
[![Version](https://img.shields.io/cocoapods/v/CodablePersistenceStore.svg?style=flat)](http://cocoapods.org/pods/CodablePersistenceStore)
[![License](https://img.shields.io/cocoapods/l/CodablePersistenceStore.svg?style=flat)](http://cocoapods.org/pods/CodablePersistenceStore)
[![Platform](https://img.shields.io/cocoapods/p/CodablePersistenceStore.svg?style=flat)](http://cocoapods.org/pods/CodablePersistenceStore)

Codable Persistence Store
===================


Hi, the Codable Persistence Store is basically a [Disk](https://github.com/saoudrizwan/Disk) wrapper. It makes your live easier while working with the new Codable Protocol.

----------


Compatibility
-------------

The Codable Persistence Store requires iOS 9+ and is compatible with Swift 4 projects. Therefore you must use Xcode 9.

Usage
-------------

First of all, you need a model which is persistable. To provide that, all you have to do is:

    struct Message: PersistableType {
    
    let id: String
    let title: String
    let body: String
    
	   static func id() -> String {
        return "messages"
	   } 
	}

PersistableType is a typealias which contains Codable and the CanBePersisted Protocol. The static function which comes down with the CanBePersisted Protocol is needed to save your **json** at the right place.

To actually persist an item all you have to do is to make an object from your struct.
e.g.: `let message = Message(id: "10", title: "Hello", body: "Whooray!")`
and after that give it to the store: `self.store.persist(message)`
Thats it.
