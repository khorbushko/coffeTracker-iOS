//
//  ExchangeFavouriteDrinkView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/8/21.
//

import Foundation
import SwiftUI

struct ExchangeFavouriteDrinkView: View {
    
    var body: some View {
        Image("ic_home_exchange")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(Pallete.brown)
            .frame(width: 30)
            .aspectRatio(1, contentMode: .fit)
            .padding(6)
    }
}

struct ExchangeFavouriteDrinkView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeFavouriteDrinkView()
            .previewLayout(.sizeThatFits)
            .frame(width: 150, height: 150)
    }
}
