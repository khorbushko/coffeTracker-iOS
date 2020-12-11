//
//  TabView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 11/30/20.
//

import Foundation
import SwiftUI

struct TabbarView: View {
    @State private var selectedIndex: Int = 0
    
    private let heightOfTabBar: CGFloat = 64
    private let tabBarColor: Color = Pallete.white
    private var safeAreaInsets: UIEdgeInsets {
        UIApplication
            .shared
            .windows
            .filter { $0.isKeyWindow }
            .first?
            .safeAreaInsets ?? .zero
    }
    
    private var buttons: [BottomBar.ButtonItem] {
        [
            BottomBar.ButtonItem(
                id: 0,
                image: Image(systemName: "pencil.and.outline"),
                text: Text("Home"),
                activeTint: Pallete.blue,
                inActiveTint: Pallete.black,
                activeIndex: $selectedIndex
            ),
            BottomBar.ButtonItem(
                id: 1,
                image: Image(systemName: "gear"),
                text: Text("Settings"),
                activeTint: Pallete.blue,
                inActiveTint: Pallete.black,
                activeIndex: $selectedIndex
            )
        ]
    }
    
    @ViewBuilder
    private var selectedTabContent: some View {
        switch selectedIndex {
        case 0:
            HomeView()
                .accessibility(identifier: "tabBarHome")
        case 1:
            SettingsView()
                .accessibility(identifier: "tabBarSettings")
        default:
            fatalError("unconfigured view for tabBar")
        }
    }
    
    private var mainContentBody: some View {
        Group {
            ZStack {
                selectedTabContent
                    .animation(.none)
                    .transition(.opacity)
                    .animation(.linear)
            }
        }
    }
        
    private var tabContent: some View {
        VStack(spacing: 0) {
            mainContentBody
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: heightOfTabBar)
        }
    }
    
    private var bottomBarContent: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            BottomBar(barButtonItems: buttons)
                .frame(height: heightOfTabBar)
                .background(
                    tabBarColor
                        .shadow(
                            color: Pallete.utilityGray,
                            radius: 1
                        )
                        .animation(.linear)
                )
                .edgesIgnoringSafeArea(.all)
                .animation(.linear(duration: 0.3))
            
            Rectangle()
                .frame(height: safeAreaInsets.bottom)
                .foregroundColor(tabBarColor)
                .animation(.linear)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
        
    var body: some View {
        ZStack {
            tabContent
            bottomBarContent
        }
    }
}


fileprivate struct BottomBar: View {
    let barButtonItems: [BottomBar.ButtonItem]
    
    struct ButtonItem: View, Identifiable {
        let id: Int
        let image: Image
        let text: Text
        let activeTint: Color
        let inActiveTint: Color
        
        @Binding var activeIndex: Int
        
        var body: some View {
            Button(
                action: {
                    withAnimation {
                        activeIndex = id
                    }
                },
                label: {
                    VStack {
                        image
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top, 8)
                            .frame(maxWidth: 32, maxHeight: 32)
                        text
                            .minimumScaleFactor(0.5)
                            .padding(.bottom, 8)
                    }
                    .foregroundColor(Pallete.white)
                    .colorMultiply(activeIndex == id ? activeTint : inActiveTint)
                    .scaleEffect(activeIndex == id ? 1 : 0.8)
                    .transition(.opacity)
                    .animation(.linear)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
            )
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                let elementWidth = geometry.size.width /
                    CGFloat(barButtonItems.count)
                ForEach(
                    barButtonItems.sorted(by: { $0.id < $1.id } )
                ) { (button) in
                    button.frame(width: elementWidth)
                }
                Spacer(minLength: 0)
            }
        }
    }
}
