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
    private let imageMapper = ImageMapper<Card>(imageURLKeyPath: \.imageURL, imageKeyPath: \.image)
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
        imageMapper.map(&cards) { _ in
            self.tableView.reloadData()
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
        let cellConfig = BasicCellConfigurator<Card>(titleKeyPath: \.description, imageKeyPath: \.image)
        cellConfig.configure(cell, for: cards[indexPath.row])
        return cell
    }
}
