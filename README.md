# ModularJSONTableView

A JSON TableView app that can display an image and title from any api that doesn't require a custom HTTPHeader. Allowing you to create basic TableViewControllers for any API in under 5 minutes. Particulary useful for take home tests.

## Setup
Just `git clone` the project there are no 3rd party dependencies.

## Using Sample Endpoints
In the `SceneDelegate` change the `typealias Endpoint` to any Endpoint within the Endpoint folder

## Creating your own Endpoint

### 1. Create a Decodable for the JSON Data you expect to recieve i.e.

#### JSON
```javascript
{
  "results": [
    {
      "id": 1,
      "name": "Rick Sanchez",
      "status": "Alive",
      "species": "Human",
      "type": "",
      "gender": "Male",
      "origin": {
        "name": "Earth",
        "url": "https://rickandmortyapi.com/api/location/1"
      },
    // ...
  ]
}
```

#### Decodable
```swift
struct RickContainer: Decodable {
    let results: [RickAndMortyCharacter]
}

struct RickAndMortyCharacter: Decodable {
    let name: String
    let imageURL: URL
    
    var description: String { name }
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "image"
        case name
    }
}
```

### 2. Add `ImageDecodable` compliance to the model your TableViewCells will use

```swift

struct RickAndMortyCharacter: ImageDecodable { //Add ImageDecodable
    let name: String
    let imageURL: URL
    
    var image: UIImage? //Add Image
    var description: String { name } //Add description that will be shown alongside image
}
```

### 3. Create Endpoint

`RootModelType`: Is the root object at the top of your JSON/Decodable heirarchy
`CellModelType`: The Decodable to be used in your TableViewCells (this may be the same as your `RootModelType`)
`url`: The URL to the API containing your JSON Data
`cellModelKeyPath`: The keypath for the property within your `RootModelType` that points to you `CellModelType` (Leave this as nil if the Root and cell models are the same)

```swift
struct RickAndMortyEndpoint: APIEndpoint {
    typealias RootModelType = RickContainer
    typealias CellModelType = RickAndMortyCharacter
    var url = URL(string: "https://rickandmortyapi.com/api/character/")!
    var modelKeyPath: KeyPath<RickContainer, [RickAndMortyCharacter]>? = \.results
}
```

### 4. Change the `EndPoint` within the `SceneDelegate to your one
```swift
typealias Endpoint = RickAndMortyEndpoint
```

## Blurb
This is a prototype I created when practising take home tests. Most companies appear to ask for identical TableView apps created from JSON objects, the only difference being the API. Rather than write the same code over and over again I wanted to come up with a reusable modular code base that could adapt to any API.

Going forward I'd like to add support for: 
* Different types of TableViewCell 
* Error handling on the network layer
* Offline data sets.
* Generated Decodables

You can find me on Twitter at [@Dec_McK](twitter.com/dec_mck)


