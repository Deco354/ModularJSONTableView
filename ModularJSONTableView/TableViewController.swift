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
            print(self?.cards ?? [])
        }
    }
}

