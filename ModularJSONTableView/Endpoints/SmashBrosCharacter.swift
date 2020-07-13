//
//  SmashBrosCharacter.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 10/07/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct SmashBrosEndpoint: APIEndpoint {
    typealias RootModelType = CharacterContainer
    typealias CellModelType = SmashBrosCharacter
    var url = URL(string: "https://www.amiiboapi.com/api/amiibo/?amiiboSeries=Super%20Smash%20Bros.")!
    var cellModelKeyPath: KeyPath<RootModelType, [CellModelType]>? = \.amiibo
}

struct CharacterContainer: Decodable {
    let amiibo: [SmashBrosCharacter]
}

struct SmashBrosCharacter: ImageDecodable {
    let imageURL: URL
    let name: String
    var image: UIImage?
    
    var description: String { name }
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "image"
        case name = "character"
    }
}
