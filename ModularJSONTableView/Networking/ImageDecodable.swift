//
//  ImageDecodable.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 07/07/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol ImageDecodable: Decodable {
    var imageURL: URL { get }
    var image: UIImage? { get set }
}
