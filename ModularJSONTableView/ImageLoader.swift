//
//  ImageLoader.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 02/07/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation
import UIKit.UIImage

/// Downloads images from a models URL property and assigns them to the model's ImageView property
struct ImageLoader<Model> {
    let imageURLKeyPath: KeyPath<Model, URL>
    let imageKeyPath: WritableKeyPath<Model, UIImage?>
    
    func downloadImages(within models: inout [Model], then imageCompletion: ((Int) -> Void)? = nil) {
        for i in models.indices {
            let imageURL = models[i][keyPath: imageURLKeyPath]
            guard let data = try? Data(contentsOf: imageURL) else { continue }
            
            models[i][keyPath: imageKeyPath] = UIImage(data: data)
            imageCompletion?(i)
        }
    }
}
