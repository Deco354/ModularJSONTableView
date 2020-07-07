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
struct ImageLoader {
    
    func downloadImages(within models: [ImageDecodable], then imageCompletion: ((UIImage?,Int) -> Void)) {
        
        for (index, model) in models.enumerated() {
            guard let data = try? Data(contentsOf: model.imageURL) else { continue }
            imageCompletion(UIImage(data: data), index)
        }
    }
}
