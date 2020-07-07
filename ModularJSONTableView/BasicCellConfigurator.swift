//
//  BasicCellConfigurator.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 02/07/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation
import UIKit.UITableViewCell

struct BasicCellConfigurator<Model> {
    let titleKeyPath: KeyPath<Model, String>
    let imageKeyPath: KeyPath<Model, UIImage?>
    
    func configure(_ cell: UITableViewCell, for model: Model) {
        cell.textLabel?.text = model[keyPath: titleKeyPath]
        cell.imageView?.image = model[keyPath: imageKeyPath]
    }
}
