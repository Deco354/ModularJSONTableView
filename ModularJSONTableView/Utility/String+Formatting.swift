//
//  String+Formatting.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 07/07/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import Foundation

extension String {
    
    /// Makes the first letter of every word upper case and the remaining letters lowercased
    func capitalized() -> String {
        let words = self.split(separator: " ")
        let capitalizedWords = words.map { $0.prefix(1).capitalized + $0.dropFirst().lowercased() }
        return capitalizedWords.joined()
    }
}
