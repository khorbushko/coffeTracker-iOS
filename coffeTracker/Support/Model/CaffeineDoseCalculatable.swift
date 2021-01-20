//
//  CaffeineDoseCalculatable.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/15/21.
//

import Foundation

public protocol CaffeineDoseCalculatable {
    var drinkDate: Date { get }
    var caffeine: Double { get }
    
    var remainingCaffeine: Double { get }
}

extension CaffeineDoseCalculatable {
    
    // Calculate the amount of caffeine remaining at the provided time,
    // based on a 5-hour half life.
    private func caffeineRemaining(fromValue mgCaffeine: Double) -> Double {
        // calculate the number of half-life time periods (5-hour increments)
        let intervals = Date().timeIntervalSince(drinkDate) / (60.0 * 60.0 * 5.0)
        let value = mgCaffeine * pow(0.5, intervals)
        return value
    }
    
    var remainingCaffeine: Double {
        caffeineRemaining(fromValue: caffeine)
    }
}
