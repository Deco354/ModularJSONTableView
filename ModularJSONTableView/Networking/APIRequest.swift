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
    private var models: [Endpoint.CellModelType] = []
    
    init(endpoint: Endpoint, session: NetworkSession = URLSession.shared) {
        self.endpoint = endpoint
        self.session = session
    }
}

extension APIRequest: NetworkRequest {
    func downloadModels(withCompletion completionHandler: @escaping ([Endpoint.CellModelType]) -> Void) {
        session.loadData(from: endpoint.url) { data,error in
            self.extractModel(from: data, with: error, dataCompletion: completionHandler)
        }
    }
    
    func downloadModels(dataCompletion: @escaping ([Endpoint.CellModelType]) -> Void, imageCompletion: @escaping ((UIImage?,Int) -> Void)) {
        session.loadData(from: endpoint.url) { data,error in
            self.extractModel(from: data, with: error, dataCompletion: dataCompletion)
            self.downloadImages(within: self.models, then: imageCompletion)
        }
    }
    
    private func extractModel(from data: Data?, with error: Error?, dataCompletion: ([Endpoint.CellModelType]) -> Void) {
        guard let data = data,
        error == nil else {
            dataCompletion([])
            print(error ?? "No Data or error found")
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
    
    private func parseModels(fromJSONObject rootJSONObject: Endpoint.RootModelType?) -> [Endpoint.CellModelType] {
        guard let rootJSONObject = rootJSONObject else {
            return []
        }
        if let modelKeyPath = self.endpoint.cellModelKeyPath {
            return rootJSONObject[keyPath: modelKeyPath]
        }
        
        if let rootJSONObject = rootJSONObject as? [Endpoint.CellModelType] {
            return rootJSONObject
        } else {
            print("\(Endpoint.CellModelType.self) needs model Keypath to point to desired property of rootJSONObject or be set to be the same as rootJSONObject")
            return []
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
    associatedtype CellModelType: ImageDecodable
    var url: URL { get }
    var cellModelKeyPath: KeyPath<RootModelType,[CellModelType]>? { get }
}
