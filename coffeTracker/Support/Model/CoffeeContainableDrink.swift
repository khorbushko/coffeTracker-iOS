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

extension CoffeeContainableDrink {
    
    // Calculate the amount of caffeine remaining at the provided time,
    // based on a 5-hour half life.
    public func caffeineRemaining(at targetDate: Date) -> Double {
        // calculate the number of half-life time periods (5-hour increments)
        if let drinkDate = drinkDate {
            let intervals = targetDate.timeIntervalSince(drinkDate) / (60.0 * 60.0 * 5.0)
            return caffeine * pow(0.5, intervals)
        }
        return 0
    }
}
