//
//  StubSession.swift
//  ModularJSONTableViewTests
//
//  Created by Declan McKenna on 13/07/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation
@testable import ModularJSONTableView

/// URLSession stub that allows code that normally accesses network to run tests locally with preconfigured responses
class StubSession: NetworkSession {
    let data: Data?
    let error: Error?
    
    init(data: Data? = nil, error: Error? = nil) {
        self.data = data
        self.error = error
    }
    
    convenience init(jsonResource: String) {
        let testBundle = Bundle(for: Self.self)
        let jsonData = testBundle.jsonData(forResource: jsonResource)
        self.init(data: jsonData, error: nil)
    }
    
    func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        completionHandler(data, error)
    }
}
