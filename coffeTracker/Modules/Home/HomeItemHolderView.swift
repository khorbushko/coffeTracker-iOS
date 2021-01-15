//
//  HomeItemHolderView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/8/21.
//

import Foundation
import SwiftUI

struct HomeItemHolderView<C: View>: View {
    
    let content: () -> C
    
    var body: some View {
        ZStack {
            Pallete.white
                .opacity(0.5)
                .cornerRadius(12)
            content()
        }
        .cornerRadius(8)
        .shadow(radius: 5)
        .padding(.top, 8)
        .padding(.horizontal, 4)
    }
}
