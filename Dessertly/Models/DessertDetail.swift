//
//  DessertDetail.swift
//  Dessertly
//
//  Created by Scott Gardner on 8/17/24.
//

import Foundation

/// Represents detailed information about a dessert.
struct DessertDetail: Decodable {
    let id: String
    let name: String

    /// Preparation instructions for the dessert. This property is optional as instructions may not be available.
    let instructions: String?

    /// Dictionary of ingredients and their corresponding measurements.
    let ingredients: [String: String]

    /// URL string for the dessert's image.
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case imageUrl = "strMealThumb"
    }

    /// Initializes a new instance of `DessertDetail` with the provided properties.
    init(id: String, name: String, instructions: String?, ingredients: [String: String], imageUrl: String) {
        self.id = id
        self.name = name
        self.instructions = instructions
        self.ingredients = ingredients
        self.imageUrl = imageUrl
    }

    /// Initializes a new instance of `DessertDetail` by decoding from the provided decoder. This initializer also reformats the instructions text and dynamically parses ingredients.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        // Reformats the `instructions` text if present.
        if let unformattedInstructions = try container.decodeIfPresent(String.self, forKey: .instructions) {
            instructions = Self.reformatText(unformattedInstructions)
        } else {
            instructions = nil
        }

        imageUrl = try container.decode(String.self, forKey: .imageUrl)

        var ingredientsDict = [String: String]()
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var index = 1

        while true {
            let ingredientKey = DynamicCodingKeys(stringValue: "strIngredient\(index)")!
            let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(index)")!

            // Check for the presence of both keys and exit if they are not found or are empty.
            guard let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: ingredientKey)?.capitalized,
                  !ingredient.isEmpty,
                  let measure = try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey),
                  !measure.isEmpty
            else {
                break
            }

            ingredientsDict[ingredient] = measure
            index += 1
        }

        ingredients = ingredientsDict
    }

    /// Reformats the given text by trimming whitespace, adding double newlines between paragraphs, and numbering each paragraph starting from 1.
    /// - Parameter text: The input text to be reformatted.
    /// - Returns: A string where each paragraph is numbered and separated by double newlines.
    static func reformatText(_ text: String) -> String {
        // Normalize line breaks to '\n' and split into paragraphs.
        let paragraphs = text.replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
            .split(separator: "\n", omittingEmptySubsequences: true)

        // Enumerate paragraphs and add a number to each one.
        let numberedParagraphs = paragraphs.enumerated().map { index, paragraph in
            "\(index + 1). \(paragraph)"
        }

        // Join paragraphs with double line breaks.
        return numberedParagraphs
            .joined(separator: "\n\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    struct DynamicCodingKeys: CodingKey {
        var stringValue: String

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int? { return nil }
        init?(intValue _: Int) { return nil }
    }
}
