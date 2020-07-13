//
//  RickAndMortyCharacter.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 10/07/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct RickAndMortyEndpoint: APIEndpoint {
    typealias RootModelType = RickContainer
    typealias CellModelType = RickAndMortyCharacter
    var url = URL(string: "https://rickandmortyapi.com/api/character/")!
    var cellModelKeyPath: KeyPath<RickContainer, [RickAndMortyCharacter]>? = \.results
}

struct RickContainer: Decodable {
    let results: [RickAndMortyCharacter]
}

struct RickAndMortyCharacter: ImageDecodable {
    let name: String
    var image: UIImage?
    let imageURL: URL
    
    var description: String { name }
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "image"
        case name
    }
}
