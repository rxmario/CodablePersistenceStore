
## Foreword 
The CodeablePersistenceStore is basically a [Disk](https://github.com/saoudrizwan/Disk) wrapper. It makes our lives easier while working with the new **Codable Protocol** which was introduced in Swift 4.

- [Compatibility](#compatibility)
- [Usage](#usage)
- [Requirements](#requirements)
- [Migration Guides](#migration-guides)
- [Communication](#communication)
- [Installation](#installation)
- [Usage](Documentation/Usage.md)

## Compatibility

The CodablePersistenceStore requires **iOS 9+** and is compatible with **Swift 4** projects. Therefore you must use Xcode 9.

## Usage

The usage is pretty straight forward. All you have to do is to let a model implement the Persistable Type Protocol which comes down when you import the CodablePersistenceStore.

### Model

    import CodablePersistenceStore

	struct Message: PersistableType {
    
    let title: String
    let body: String
    
	   static func id() -> String {
        return "hey"
	   }
	}

### Persist

To actually persist data all you have to do is create an object from your model and put it into the persist method. There are currently two types of persist methods. The first one is synchronous, the second one is asynchronous.
	
	let message = Message(title: "Hello", body: "World!")
	
    self.persistenceStore.persist(message)

    self.persistenceStore.persist(message, completion: {
     // do stuff afterwards e.g. stop activity indicator
    })

### Retrieve
Retrieving your persisted data is pretty straight forward. There are always synchronous and asynchronous methods.

    let message = self.persistenceStore.get("id", type: Message.self)

	self.persistenceStore.get("id", type: Message.self, completion: { (message) in 
		// asynchronous
	})

If you got tons of messages for example and you want them all you could just call the following method:

    let messages = self.persistenceStore.getAll(Message.self)
	
	self.persistenceStore.getAll(Message.self, completion: { (messages) in
		// asynchronous 
	}) 



