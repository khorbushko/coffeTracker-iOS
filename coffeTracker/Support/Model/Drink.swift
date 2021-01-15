//
//  Drink.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/8/21.
//

import Foundation

struct Drink: CoffeeContainableDrink, Codable, Equatable {
    
    var caffeine: Double
    var calories: Double
    var image: String
    var isFavourite: Bool
    var measurementUnit: String
    var name: String
    var servingSize: Int64
    var unit: String
    var uuid: String
    var drinkDate: Date?
    var displayOrder: Int
    
    init(
        caffeine: Double,
        calories: Double,
        image: String,
        isFavourite: Bool,
        measurementUnit: String,
        name: String,
        servingSize: Int64,
        unit: String,
        uuid: String,
        drinkDate: Date? = nil,
        displayOrder: Int
        ) {
        self.caffeine = caffeine
        self.calories = calories
        self.image = image
        self.isFavourite = isFavourite
        self.measurementUnit = measurementUnit
        self.name = name
        self.servingSize = servingSize
        self.unit = unit
        self.uuid = uuid
        self.drinkDate = drinkDate
        self.displayOrder = displayOrder
    }

    private enum Key: String, CodingKey {
        
        case caffeine
        case calories
        case image
        case isFavourite
        case measurementUnit
        case name
        case servingSize
        case unit
        case uuid
        case drinkDate
        case displayOrder
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Self.Key.self)

        caffeine = try container.decode(.caffeine)
        calories = try container.decode(.calories)
        image = try container.decode(.image)
        isFavourite = try container.decode(.isFavourite)
        measurementUnit = try container.decode(.measurementUnit)
        name = try container.decode(.name)
        servingSize = try container.decode(.servingSize)
        unit = try container.decode(.unit)
        uuid = (try? container.decodeIfPresent(.uuid)) ?? UUID().uuidString
        drinkDate = try? container.decodeIfPresent(.drinkDate)
        displayOrder = try container.decode(.displayOrder)
    }
}
