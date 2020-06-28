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
    func load(withCompletion completionHandler: @escaping ([Endpoint.ModelType]?) -> Void) {
        session.loadData(from: endpoint.url) { [weak self] data,_ in
            guard let data = data else {
                completionHandler(nil)
                return
            }
            completionHandler(self?.decode(data))
        }
    }
    
    func decode(_ data: Data) -> [Endpoint.ModelType]? {
        let decoder = JSONDecoder()
        let rawResponse = try? decoder.decode(JSONArrayContainer<Endpoint.ModelType>.self, from: data)
        return rawResponse?.items
    }
}


protocol APIEndpoint {
    associatedtype ModelType: Decodable
    var url: URL { get }
}
