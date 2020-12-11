//
//  ContainerView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 12/1/20.
//

import Foundation
import SwiftUI

struct RootContainerView: View {
    
    @ObservedObject private var viewModel: RootContainerViewModel
    @State private var displayPermission: Bool = false
    @State private var overlayOpacityValue: CGFloat = 0
    
    init() {
        let storage = EnvironmentValueStorage()
        viewModel = RootContainerViewModel(healthStore: storage.healthStore)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TabbarView()
                
                Color.black.opacity(0.5)
                    .opacity(Double(overlayOpacityValue))
                    .edgesIgnoringSafeArea(.all)
                BottomSheetView(
                    isOpen: $displayPermission,
                    openPercentage: $overlayOpacityValue,
                    isDraggable: false,
                    maxHeight: geometry.size.height * 0.9,
                    minHeight: -geometry.safeAreaInsets.bottom
                ) {
                    IntroView(isShown: $displayPermission)
                }
            }
        }
        .animation(.easeOut)
        .onReceive(viewModel.$shouldAskPermission, perform: { value in
            displayPermission = value
        })
    }
}

struct RootContainerView_Previews: PreviewProvider {
    static var previews: some View {
        RootContainerView()
    }
}
