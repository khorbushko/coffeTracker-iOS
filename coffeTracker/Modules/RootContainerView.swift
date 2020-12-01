//
//  ContainerView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 12/1/20.
//

import Foundation
import SwiftUI
import Combine

final class RootContainerViewModel: ObservableObject {
    
    @Environment(\.healthKitService)
    private var healthStore

    @Published var shouldAskPermission: Bool = false
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        healthStore.shouldAskDataAccess()
            .sink { (value) in
                self.shouldAskPermission = value
            }
            .store(in: &subscriptions)
    }
}

struct RootContainerView: View {
    
    @ObservedObject
    private var viewModel: RootContainerViewModel = RootContainerViewModel()
    @State private var displayPermission: Bool = false
    
    var body: some View {
        VStack {
            if displayPermission {
                IntroView()
            } else {
                TabbarView()
            }
        }
        .transition(.scale)
        .animation(.easeOut)
        .onReceive(viewModel.$shouldAskPermission, perform: { value in
            withAnimation {
                displayPermission = value
            }
        })
    }
}
