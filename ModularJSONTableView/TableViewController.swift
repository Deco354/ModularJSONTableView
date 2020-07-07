//
//  ViewController.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 22/06/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import UIKit

class TableViewController<Endpoint: APIEndpoint>: UITableViewController {
    private let apiEndpoint: Endpoint
    private let imageLoader = ImageLoader()
    private lazy var apiRequest = APIRequest(endpoint: apiEndpoint)
    var cards: [Endpoint.ModelType] = []
    
    init?(coder: NSCoder, endpoint: Endpoint) {
        self.apiEndpoint = endpoint
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Dependencies were not injected")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadCards()
    }
    
    private func downloadCards() {
        apiRequest.load { [weak self] deck in
            guard let self = self,
            let deck = deck else {
                return
            }
            if let modelKeyPath = self.apiEndpoint.modelKeyPath {
                self.cards = deck[keyPath: modelKeyPath]
            } else {
                //self.cards = deck as? Endpoint.ModelType
            }
            self.refreshTable()
            self.imageLoader.downloadImages(within: self.cards, then: self.displayImage(_:forRow:))
        }
    }
    
    /// Refreshes TableView on main thread
    private func refreshTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func displayImage(_ image: UIImage?, forRow row: Int) {
        cards[row].image = image
        refreshRow(row)
    }
    
    private func refreshRow(_ row: Int) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let card = cards[indexPath.row]
        cell.imageView?.image = card.image
        cell.textLabel?.text = card.description
        return cell
    }
}
