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
    private let imageLoader = ImageLoader<Card>(imageURLKeyPath: \.imageURL, imageKeyPath: \.image)
    private lazy var apiRequest = APIRequest(endpoint: cardEndpoint)
    var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadCards()
    }
    
    private func downloadCards() {
        apiRequest.load { [weak self] deck in
            guard let self = self else { return }
            self.cards = deck?.cards ?? []
            self.refreshTable()
            self.imageLoader.downloadImages(within: &self.cards, then: self.refreshRow(_:))
        }
    }
    
    /// Refreshes TableView on main thread
    private func refreshTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func refreshRow(_ row: Int) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)
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
        print(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let cellConfig = BasicCellConfigurator<Card>(titleKeyPath: \.description, imageKeyPath: \.image)
        cellConfig.configure(cell, for: cards[indexPath.row])
        return cell
    }
}
