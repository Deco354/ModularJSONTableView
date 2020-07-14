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

extension Bundle {
    /// Convert a local .json resource in to `Data`. This can be used with with `StubSession` to generate fake URLSession returns for local testing
    func jsonData(forResource resourceName: String) -> Data {
        guard let url = self.url(forResource: resourceName, withExtension: "json"),
        let data = try? Data(contentsOf: url)
        else {
            fatalError("\(resourceName).json could not be found")
        }
        return data
    }
}
