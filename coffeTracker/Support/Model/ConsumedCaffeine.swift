//
//  ConsumedCaffeine.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/15/21.
//

import Foundation

struct ConsumedCaffeine {
    
    var caffeine: Double
    var unit: String
    var uuid: String
    var drinkDate: Date
    
    var sourceName: String?
}

extension ConsumedCaffeine: CaffeineDoseCalculatable { }
