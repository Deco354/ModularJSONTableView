//
//  ImageRequest.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 23/06/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import UIKit.UIImage

class ImageRequest {
    private let session: NetworkSession
    private let url: URL
    
    init(url: URL, session: NetworkSession = URLSession.shared) {
        self.url = url
        self.session = session
    }
    
}

extension ImageRequest: NetworkRequest {
    typealias ReturnType = UIImage
        
    func load(withCompletion completionHandler: @escaping (UIImage?) -> Void) {
        guard let data = try? Data(contentsOf: url) else {
            completionHandler(nil)
            return
        }
        completionHandler(decode(data))
    }
    
    func decode(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
