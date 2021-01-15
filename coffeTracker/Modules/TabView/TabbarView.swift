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
    
    private var activeTabBarTint: Color = Pallete.brown
    private var inactiveTabBarTint: Color = Pallete.utilityGray

    private var buttons: [BottomBar.ButtonItem] {
        [
            BottomBar.ButtonItem(
                id: 0,
                image: Image("ic_tabBar_home"),
                text: Text("Home"),
                activeTint: activeTabBarTint,
                inActiveTint: inactiveTabBarTint,
                activeIndex: $selectedIndex
            ),
            BottomBar.ButtonItem(
                id: 1,
                image: Image("ic_tabBar_settings"),
                text: Text("Settings"),
                activeTint: activeTabBarTint,
                inActiveTint: inactiveTabBarTint,
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
                            .padding(.top, 6)
                            .frame(idealWidth: 32, idealHeight: 32)
                        text
                            .minimumScaleFactor(0.5)
                            .padding(.bottom, 6)
                            .padding(.top, -6)
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
