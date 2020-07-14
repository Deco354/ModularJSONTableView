//
//  APIRequestTests.swift
//  ModularJSONTableViewTests
//
//  Created by Declan McKenna on 13/07/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import XCTest
import UIKit.UIImage
@testable import ModularJSONTableView

class APIRequestTests: XCTestCase {
    var cards: [Card] = []
    var expectedCards: [Card] { return try! JSONDecoder().decode(Deck.self, from: Bundle(for: Self.self).jsonData(forResource: "Card")).cards }
    var testBundle: Bundle { Bundle(for: Self.self) }

    func testDownloadModels() throws {
        let expectedCards = try JSONDecoder().decode(Deck.self, from: Bundle(for: Self.self).jsonData(forResource: "Card")).cards
        
        let apiRequest = APIRequest(endpoint: CardEndpoint(), session: StubSession(jsonResource: "Card"))
        apiRequest.downloadModels { cards in
            self.cards = cards
        }
        XCTAssertEqual(cards, expectedCards)
    }
    
    func testDownloadModelsAndImages() {
        let expectedImages: [UIImage] = [
            UIImage(named: "JC", in: testBundle, with: nil)!,
            UIImage(named: "2H", in: testBundle, with: nil)!
        ]
        var expectedRow = 0
        
        let stubImageURLJSON = try! JSONEncoder().encode(Deck(cards: stubCardImageURLs()))
        let apiRequest = APIRequest(endpoint: CardEndpoint(), session: StubSession(data: stubImageURLJSON, error: nil))
        apiRequest.downloadModels(dataCompletion: { cards in
            self.cards = cards
        }) { (image, row) in
            XCTAssertEqual(row, expectedRow)
            XCTAssertEqual(image?.pngData(), expectedImages[row].pngData())
            expectedRow += 1
        }
    }
    
    private func stubCardImageURLs() -> [Card] {
        let localCardImageURL = Bundle(for: Self.self).url(forResource: "JC", withExtension: ".png")!
        let localCardImageURL2 = testBundle.url(forResource: "2H", withExtension: ".png")!
        let stubbedCards: [Card] = [
            Card(imageURL: localCardImageURL, value: "JACK", suit: "CLUBS", image: nil),
            Card(imageURL: localCardImageURL2, value: "2", suit: "HEARTS", image: nil)
        ]
        return stubbedCards
    }
}
