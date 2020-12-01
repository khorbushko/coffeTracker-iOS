//
//  IntroView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 11/30/20.
//

import Foundation
import SwiftUI
import Combine

struct IntroView: View {
    
    private var viewModel: IntroViewModel = IntroViewModel()
        
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Image("ic_intro_healthKit")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 100)
                    Spacer()
                }
                .frame(height: 100)
                Text("This application require access to your HealthKit data in order to calculate, predict and analyze all inputs.")
            }
            
            HStack {
                Text("To continue, press \"Next\" button...")
                    .padding(.top, 8)
                Spacer()
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                viewModel.perform(.next)
            }, label: {
                Text("Next")
            })
            .buttonStyle(ViewStyle.Button.PrimaryStyle())
        }
        .padding()
        .onReceive(viewModel.$isNextButtonPressed, perform: { _ in
            
        })
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
