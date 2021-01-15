//
//  DrinkView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/8/21.
//

import Foundation
import SwiftUI

struct DrinkView: View {
    
    let item: CoffeeContainableDrink
    var action: () -> Void
    
    @State private var checkMarkPathVisibilityAmount: CGFloat = 0
    @State private var appearenceOpacity: Double = 0
    @State private var isAnimationInProgress: Bool = false
    
    private var buttonContent: some View {
        ZStack {
            Image(item.image)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding(6)
                .padding(.bottom, 8)
            VStack {
                Spacer()
                Text(item.name)
                    .foregroundColor(Pallete.white)
                    .font(.system(size: 14, weight: .regular))
                    .padding()
                    .shadow(color: Pallete.black, radius: 2)
            }
            ZStack {
                Pallete.gray
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .scaleEffect(2)
            HStack {
                    Checkmark()
                        .trim(from: 0, to: checkMarkPathVisibilityAmount)
                        .stroke(
                            Pallete.green,
                            style: StrokeStyle(
                                lineWidth: 10,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                        .aspectRatio(contentMode: .fit)
                        .animation(appearenceOpacity == 0 ? .none : .easeIn)
            }
            .padding(8)
            }
            .opacity(appearenceOpacity)
            .onAnimationCompleted(for: checkMarkPathVisibilityAmount) {
                if checkMarkPathVisibilityAmount == 1 {
                    appearenceOpacity = 0
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        checkMarkPathVisibilityAmount = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isAnimationInProgress = false
                        }
                    }
                }
            }
        }
    }

    var body: some View {
        HomeItemHolderView {
            
            Button(action: {
                if !isAnimationInProgress {
                    appearenceOpacity = 1
                    checkMarkPathVisibilityAmount = 1
                    isAnimationInProgress = true
                    
                    action()
                }
            }, label: {
                buttonContent
            })
            .buttonStyle(ScaleButtonStyle())
            .animation(.easeOut)
            .allowsHitTesting(!isAnimationInProgress)
        }
    }
}

struct DrinkView_Previews: PreviewProvider {
    static var previews: some View {
        let item = Drink(
            caffeine: 12,
            calories: 12,
            image: "icons-1-espresso",
            isFavourite: true,
            measurementUnit: "mg",
            name: "Espresso",
            servingSize: 50,
            unit: "ml",
            uuid: "",
            displayOrder: 1
        )

        DrinkView(item: item,
//                  isTapped: .constant(false),
                  action: {}
        )
            .previewLayout(.sizeThatFits)
            .frame(width: 150, height: 150)
    }
}
