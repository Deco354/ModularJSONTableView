//
//  APIRequest.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 24/06/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation

class APIRequest<Resource: APIEndpoint>  {
    private let resource: Resource
    private let session: NetworkSession
    
    init(resource: Resource, session: NetworkSession = URLSession.shared) {
        self.resource = resource
        self.session = session
    }
}


protocol APIEndpoint {
    associatedtype ModelType: Decodable
    var url: URL { get }
}
