//
//  NetworkRequest.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 22/06/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation

protocol NetworkRequest {
    associatedtype ReturnType
    func load(withCompletion completionHandler: @escaping (ReturnType?) -> Void)
    func decode(_ data: Data) -> ReturnType?
}
