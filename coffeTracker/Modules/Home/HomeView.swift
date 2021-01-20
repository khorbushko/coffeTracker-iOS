//
//  ContentView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 11/26/20.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var viewModel: HomeViewModel
    
    @ViewBuilder
    private var reportCoffeeView: some View {
        Group {
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
                                viewModel.saveDrink(item)
                            }
                        )
                    }
                }
                .delayedAnimation(animation: .linear)
                .font(.largeTitle)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var last24HDrinkInfoView: some View {
        VStack {
            Text("Consumed \(viewModel.consumedCoffeine)")
            Text("Active \(viewModel.activeCoffeine)")
        }
    }
    
    // MARK: - Lifecycle
    
    init() {
        let healthStore = EnvironmentValueStorage().healthStore
        viewModel = HomeViewModel(healthStore)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    reportCoffeeView
                    last24HDrinkInfoView
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
            .onAppear(perform: {
                viewModel.fetchTodaysDrink()
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
