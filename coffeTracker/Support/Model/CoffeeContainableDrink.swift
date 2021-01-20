//
//  Drinkable.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/8/21.
//

import Foundation

protocol CoffeeContainableDrink {
    
    var caffeine: Double { get set }
    var calories: Double { get set }
    var image: String { get set }
    var isFavourite: Bool { get set }
    var measurementUnit: String { get set }
    var name: String { get set }
    var servingSize: Int64 { get set }
    var unit: String { get set }
    var uuid: String { get set }
    var displayOrder: Int { get set }
    
    var drinkDate: Date? { get set }
}

extension CoffeeContainableDrink where Self: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
