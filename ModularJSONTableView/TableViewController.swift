//
//  ViewController.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 22/06/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import UIKit

class TableViewController<Endpoint: APIEndpoint>: UITableViewController {
    private let apiRequest: APIRequest<Endpoint>
    var models: [Endpoint.CellModelType] = []
    
    init?(coder: NSCoder, apiRequest: APIRequest<Endpoint>) {
        self.apiRequest = apiRequest
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Dependencies were not injected")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiRequest.downloadModels(dataCompletion: refreshModels, imageCompletion: refreshImage)
    }
    
    private func refreshModels(_ models: [Endpoint.CellModelType]) {
        self.models = models
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func refreshImage(_ image: UIImage?, forRow row: Int) {
        models[row].image = image
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let card = models[indexPath.row]
        cell.imageView?.image = card.image
        cell.textLabel?.text = card.description
        return cell
    }
}
