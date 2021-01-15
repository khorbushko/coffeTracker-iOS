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
    @State private var startSplashAnimation: Bool = false
    @State private var finalizeSplashAnimation: Bool = false
    
    private var splashAnimationView: some View {
        ZStack {
            Color("color_splash_background")
            Image("ic_splash_icon")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: startSplashAnimation ? .fill : .fit)
                .frame(width: startSplashAnimation ? nil : 150, height: startSplashAnimation ? nil : 228)
                .scaleEffect(startSplashAnimation ? 3 : 1)
                .frame(width: UIScreen.main.bounds.width)
            
        }
    }
    
    // MARK: - Lifecycle
    
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
                    PermissionRequestView(isShown: $displayPermission)
                }
                
                splashAnimationView
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: animateAppearence)
                .opacity(finalizeSplashAnimation ? 0 : 1)
                .onChange(of: finalizeSplashAnimation, perform: { value in
                    if value {
                        viewModel.checkAppleHealthRequest()
                    }
                })
            }
        }
        .animation(.easeOut)
        .onReceive(
            viewModel.$shouldAskPermission
                .receive(on: DispatchQueue.main),
            perform: { value in
                displayPermission = value
            }
        )
    }
    
    // MARK: - Private
    
    private func animateAppearence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.easeOut(duration: 0.45)) {
                startSplashAnimation = true
            }

            withAnimation(.easeOut(duration: 0.35)) {
                finalizeSplashAnimation = true
            }
        }
    }
}

struct RootContainerView_Previews: PreviewProvider {
    static var previews: some View {
        RootContainerView()
        RootContainerView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 7"))

    }
}
