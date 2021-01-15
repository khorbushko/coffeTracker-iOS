//
//  InitialDataController.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 12/29/20.
//

import Foundation

enum DrinkProvider {
    
    static func populateInitialDataIfNeeded() {
        let availableDrinks = CDDrink.fetchInMainContext()
        if availableDrinks == nil || availableDrinks?.isEmpty == true {
            
            if let path = Bundle.main.path(forResource: "predefinedDrinks", ofType: "json") {
                let url = URL(fileURLWithPath: path)
                if let data = try? Data(contentsOf: url) {
                    do {
                        let results = try JSONDecoder().decode([Drink].self, from: data)
                        
                        let objectsToStore = results
                            .compactMap(CDDrink.createFrom(_:))
                        if objectsToStore.count == results.count {
                            try PersistenceController.mainContext.save()
                        } else {
                            assertionFailure("convertion issue while store predefined data")
                        }
                        
                    } catch {
                        print(error)
                    }
                    
                }
            }
            
        }
    }
}
