//
//  APIRequest.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 24/06/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation
import UIKit.UIImage

class APIRequest<Endpoint: APIEndpoint>  {
    private let endpoint: Endpoint
    private let session: NetworkSession
    private var models: [Endpoint.ModelType] = []
    
    init(endpoint: Endpoint, session: NetworkSession = URLSession.shared) {
        self.endpoint = endpoint
        self.session = session
    }
}

extension APIRequest: NetworkRequest {
    func downloadModels(withCompletion completionHandler: @escaping ([Endpoint.ModelType]) -> Void) {
        session.loadData(from: endpoint.url) { data,error in
            self.extractModel(from: data, with: error, dataCompletion: completionHandler)
        }
    }
    
    func downloadModels(dataCompletion: @escaping ([Endpoint.ModelType]) -> Void, imageCompletion: @escaping ((UIImage?,Int) -> Void)) {
        session.loadData(from: endpoint.url) { data,error in
            self.extractModel(from: data, with: error, dataCompletion: dataCompletion)
            self.downloadImages(within: self.models, then: imageCompletion)
        }
    }
    
    private func extractModel(from data: Data?, with error: Error?, dataCompletion: ([Endpoint.ModelType]) -> Void) {
        guard let data = data else {
            dataCompletion([])
            return
        }
        let rootModel = decode(data)
        models = parseModels(fromJSONObject: rootModel)
        dataCompletion(models)
    }
    
    private func downloadImages(within models: [ImageDecodable], then imageCompletion: ((UIImage?,Int) -> Void)) {
        
        for (index, model) in models.enumerated() {
            guard let data = try? Data(contentsOf: model.imageURL) else { continue }
            imageCompletion(UIImage(data: data), index)
        }
    }
    
    private func parseModels(fromJSONObject rootJSONObject: Endpoint.RootModelType?) -> [Endpoint.ModelType] {
        guard let rootJSONObject = rootJSONObject else {
            return []
        }
        if let modelKeyPath = self.endpoint.modelKeyPath {
            return rootJSONObject[keyPath: modelKeyPath]
        } else {
            return rootJSONObject as? [Endpoint.ModelType] ?? []
        }
    }
    
    func decode(_ data: Data) -> Endpoint.RootModelType? {
        let decoder = JSONDecoder()
        
        do {
            let rawResponse = try decoder.decode(Endpoint.RootModelType.self, from: data)
            return rawResponse
        } catch(let error) {
            print(error)
            return nil
        }
    }
}


protocol APIEndpoint {
    associatedtype RootModelType: Decodable
    associatedtype ModelType: ImageDecodable
    var url: URL { get }
    var modelKeyPath: KeyPath<RootModelType,[ModelType]>? { get }
}
