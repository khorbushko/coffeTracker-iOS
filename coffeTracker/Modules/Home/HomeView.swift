//
//  ContentView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 11/26/20.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var viewModel: HomeViewModel
    
    // MARK: - Lifecycle
    
    init() {
        let healthStore = EnvironmentValueStorage().healthStore
        viewModel = HomeViewModel(healthStore)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    let columns: [GridItem] = .init(
                        repeatElement(
                            GridItem(),
                            count: 3
                        )
                    )
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.drinks, id: \.uuid) { item in
                                DrinkView(
                                    item: item,
                                    action: {
                                        //                                    viewModel.saveDrink(item)
                                    }
                                )
                            }
                        }
                        .delayedAnimation(animation: .linear)
                        .font(.largeTitle)
                    }
                    .padding()
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Dashboard")
            .navigationBarItems(
                trailing:
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            ExchangeFavouriteDrinkView()
                        }
                    )
            )
            .onAppear(perform: {
                viewModel.requestDrinks()
            })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContextView {
            HomeView()
        }
    }
}
