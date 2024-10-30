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
        case let .key(string): return string
        }
    }

    init?(stringValue: String) {
        self = .key(stringValue)
    }

    var intValue: Int? { return nil }
    init?(intValue _: Int) { return nil }
}
