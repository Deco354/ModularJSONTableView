//
//  ViewController.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 22/06/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    private let cardEndpoint = CardEndpoint()
    private lazy var apiRequest = APIRequest(endpoint: cardEndpoint)
    var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadCards()
    }
    
    private func downloadCards() {
        apiRequest.load { [weak self] deck in
            self?.cards = deck?.cards ?? []
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            self?.downloadImages()
        }
    }
    
    private func downloadImages() {
        for i in cards.indices {
            let cardImageURL = cards[i].imageURL
            let imageRequest = ImageRequest(url: cardImageURL)
            imageRequest.load { image in
                DispatchQueue.main.async {
                    self.cards[i].image = image
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension TableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let card = cards[indexPath.row]
        cell.textLabel?.text = "\(card.value) of \(card.suit)"
        cell.imageView?.image = card.image
        return cell
    }
}
