//
//  Card.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 26/06/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation

import Foundation
import UIKit.UIImage

struct CardEndpoint: APIEndpoint {
    typealias ModelType = Card
    var url = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=52")!
}

struct Cards: Decodable {
    let cards: [Card]
}

struct Card: Decodable {
    let imageURL: URL
    let value: String
    let suit: String
    var image: UIImage? // This should be adapted to have value semantics
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "image"
        case value, suit
    }
}
