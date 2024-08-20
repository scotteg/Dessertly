//
//  DynamicCodingKeys.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/17/24.
//

import Foundation

enum DynamicCodingKeys: CodingKey {
    case key(String)
    
    var stringValue: String {
        switch self {
        case .key(let string): return string
        }
    }
    
    init?(stringValue: String) {
        self = .key(stringValue)  // Use 'stringValue' directly in the initializer
    }
    
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
}
