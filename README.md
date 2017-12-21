
## Foreword 
The CodeablePersistenceStore is basically a [Disk](https://github.com/saoudrizwan/Disk) wrapper. It makes our lives easier while working with the new **Codable Protocol** which was introduced in Swift 4.

- [Compatibility](##compatibility)
- [Usage](##usage)
	- [Model](#model)
	- [Persist](#persist)
	- [Retrieve](#retrieve)
	- [Delete](#delete)
	- [Filter](#filter)
	- [Exists](#exists)
	- [Clear](#clear)
- [Installation](#installation)
- [License](#license)

## Compatibility

The CodablePersistenceStore requires **iOS 9+** and is compatible with **Swift 4** projects. Therefore you must use Xcode 9.

## Usage

The usage is pretty straight forward. All you have to do is to let a model implement the Persistable Type Protocol which comes down with the CodablePersistenceStore import.

**Important!!!**
All of the methods you see in the documentation can throw. So don't forget to handle exceptions.

### Model

    import CodablePersistenceStore
    
	// Its an example.
	struct Message: PersistableType {
    
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

### Persist

To actually persist data all you have to do is create an object from your model and put it into the persist method. There are currently two types of persist methods. The first one is synchronous, the second one is asynchronous.
	
	let message = Message(id: "10", title: "Hello", body: "World!")
    self.persistenceStore.persist(message)
 
 Thats basically all you gotta do. Theres also a version with a completion handler to do things afterwards.

    let message = Message(id: "10", title: "Hello", body: "World")
    self.persistenceStore.persist(message, completion: { 
		// do some stuff afterwards
	})

### Retrieve
Retrieving your persisted data is pretty straight forward. There are always synchronous and asynchronous methods.

    let message = self.persistenceStore.get("id", type: Message.self)

That simple.

If you want it to be asynchronous, there you go:

    self.persistenceStore.get("id", type: Message.self, completion: { (message) in 
		// your message should be here right now
	})


If you got tons of messages for example and you want them all you could just call the following method:

    let messages = self.persistenceStore.getAll(Message.self)
	
Or asynchronous:

    self.persistenceStore.getAll(Message.self, completion: { (messages) in 
		// your messages should be here
	})
	
### Delete
 There are a few ways to delete items. Its pretty self explaining.
 Imagine you already got some persisted messages.

    self.persistenceStore.delete(message)
   
   Of course there is a version which lets you do things after deleting something (e.g. reloading tableview)

    self.persistenceStore.delete(message, completion: { 
		// do things afterwards
	})

But there is another version which needs an identifier and the type you want to delete.

    self.persistenceStore.delete("10", type: Message.self)
 
 With completion:

    self.persistenceStore.delete("10", type: Message.self, completion: {
		// do things afterwards
	})

### Filter
You can filter all your items from the same type by properties. For example:

    let itemWithID10 = self.persistenceStore.filter(Message.self, includeElement: { (item: Message) -> Bool in
    	return item.id == "10"
    }).first

Or asynchronous:

	 self.persistenceStore.filter(Message.self, includeElement: { (item: Message) -> Bool in
	 return item.id == "10"
	}, completion: { (item) in
		print(item.id)
	})

### Exists
You could check right before persisting some data if the item you're about to persist already exists in the store:

    let isAlreadyInStore = self.persistenceStore.exists(message1)

Asynchronous:

    self.persistenceStore.exists(message1, completion: { (bool) in 
		
		guard bool == false else { return }
		
		// do stuff afterwards
	
	})

More options:

    let isAlreadyInStore = self.persistenceStore.exists("10", type: Message.self)
   
   Or Async: 

    self.persistenceStore.exists("10", type: Message.self, completion: { (bool) in 
		
		guard bool == false else { return }
		
		// to stuff afterwards
		
	})

### Clear

To clear the whole cache, all you've to do is call:

    self.persistenceStore.cacheClear()

## Installation

To integrate the CodablePersistenceStore into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'CodablePersistenceStore', '~>1.0.1.alpha'
end
```

Then, run the following command:

```bash
$ pod install
```


## License

The CodablePersistenceStore is released under the MIT license.
