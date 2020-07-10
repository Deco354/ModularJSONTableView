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
    typealias RootModelType = Deck
    typealias CellModelType = Card
    var url = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=52")!
    var cellModelKeyPath: KeyPath<RootModelType,[CellModelType]>? = \.cards
}

/// Container for JSON object that contains cards
struct Deck: Decodable {
    let cards: [Card]
}

struct Card: ImageDecodable {
    let imageURL: URL
    let value: String
    let suit: String
    var image: UIImage?
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "image"
        case value, suit
    }
}

extension Card {
    var description: String { "\(value.capitalized()) of \(suit.capitalized())" }
}
