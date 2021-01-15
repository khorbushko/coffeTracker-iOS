//
//  StorableObjects+Coffe.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 12/29/20.
//

import Foundation

extension CDDrink: StorableObject { }

extension CDDrink {
    
    static var isFavouritePredicate: NSPredicate {
        NSPredicate(format: "isFavourite == YES")
    }
}

extension StorableObject where Self: CDDrink {
    
    static func fetchAllFavourites() -> [Self]? {
        ManagedObjectManager.fetchIn(
            PersistenceController.mainContext,
            predicate: CDDrink.isFavouritePredicate
        )
    }
}

extension CDDrink {
    
    func coffeeDrink() -> CoffeeContainableDrink? {
        if let image = image,
           let name = name,
           let unit = unit,
           let measurementUnit = measurementUnit,
           let uuid = uuid {
            return Drink(
                caffeine: caffeine,
                calories: calories,
                image: image,
                isFavourite: isFavourite,
                measurementUnit: measurementUnit,
                name: name,
                servingSize: servingSize,
                unit: unit,
                uuid: uuid,
                displayOrder: Int(displayOrder)
            )
        }
        
        return nil
    }
    
    static func createFrom(_ drink: CoffeeContainableDrink) -> CDDrink {
        let newDrink = CDDrink.create()
        newDrink.caffeine = drink.caffeine
        newDrink.image = drink.image
        newDrink.measurementUnit = drink.measurementUnit
        newDrink.name = drink.name
        newDrink.servingSize = drink.servingSize
        newDrink.unit = drink.unit
        newDrink.isFavourite = drink.isFavourite
        newDrink.calories = drink.calories
        newDrink.uuid = drink.uuid
        newDrink.displayOrder = Int64(drink.displayOrder)
        
        return newDrink
    }
}
