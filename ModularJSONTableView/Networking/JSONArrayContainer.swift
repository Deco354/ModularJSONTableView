//
//  JSONArrayContainer.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 28/06/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

/// This is required to return an array of Decodables from a JSON object when the array
/// is not at the top level of the object's structure
struct JSONArrayContainer<T: Decodable>: Decodable {
    let items: [T]
}
