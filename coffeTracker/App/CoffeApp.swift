//
//  coffeTrackerApp.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 11/26/20.
//

import SwiftUI

@main
struct CoffeApp: App {
    
    init() {
        DrinkProvider.populateInitialDataIfNeeded()
    }
    
    var body: some Scene {
        WindowGroup {
            RootContainerView()
                .environment(
                    \.managedObjectContext,
                    PersistenceController.mainContext
                )
        }
    }
}
