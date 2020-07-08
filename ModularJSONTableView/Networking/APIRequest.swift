//
//  APIRequest.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 24/06/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation

class APIRequest<Endpoint: APIEndpoint>  {
    private let endpoint: Endpoint
    private let session: NetworkSession
    
    init(endpoint: Endpoint, session: NetworkSession = URLSession.shared) {
        self.endpoint = endpoint
        self.session = session
    }
}

extension APIRequest: NetworkRequest {
    func load(withCompletion completionHandler: @escaping ([Endpoint.ModelType]) -> Void) {
        session.loadData(from: endpoint.url) { [weak self] data,_ in
            guard let data = data else {
                completionHandler([])
                return
            }
            let rootModel = self?.decode(data)
            let models = self?.parseModels(fromJSONObject: rootModel)
            completionHandler(models ?? [])
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
