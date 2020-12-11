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
    @Binding var isShown: Bool
    @Namespace private var introNamespace
    @ObservedObject private var viewModel: IntroViewModel
    @State private var checkMarkPathVisibilityAmount: CGFloat = 0
    @State private var crossMarkPathVisibilityAmount: CGFloat = 0

    init(isShown: Binding<Bool>) {
        _isShown = isShown
        let storage = EnvironmentValueStorage()
        viewModel = IntroViewModel(healthStore: storage.healthStore)
    }
    
    @ViewBuilder
    private var informativeContent: some View {
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
            Text("This application require access to your HealthKit data in order to calculate, predict and analyze consumed drinks.")
        }
        
        HStack {
            Text("To continue, press \"Next\" button...")
            Spacer()
        }
        .padding()
        .opacity(viewModel.state == .initial ? 1 : 0)
        Spacer()
    }
    
    @ViewBuilder
    private var bottomButtons: some View {
        LoadingButton(
            loading: .constant(viewModel.state == .requested),
            foregroundColor: Pallete.white,
            backgroundColor: Pallete.blue,
            action: {
                viewModel.perform(.next)
            },
            label: Text("Next")
        )
        .opacity(viewModel.state.isResponseReceived ? 0 : 1)
        .matchedGeometryEffect(
            id: viewModel.state.isResponseReceived ? "bottomButton" : "n/a",
            in: introNamespace
        )
        
        LoadingButton(
            loading: .constant(false),
            foregroundColor: Pallete.white,
            backgroundColor: Pallete.blue,
            action: {
                isShown = false
            },
            label: Text("Let me drink the coffee!")
        )
        .opacity(viewModel.state.isResponseReceived ? 1 : 0)
        .matchedGeometryEffect(id: "bottomButton", in: introNamespace)
    }
    
    private var checkmark: some View {
        VStack {
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
                .frame(width: 100, height: 100)
                .animation(.easeOut)
            Text("Request to AppleHealth succeed")
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(Pallete.utilityGray.opacity(0.5))
                .opacity(Double(checkMarkPathVisibilityAmount))
        }
    }
    
    @ViewBuilder
    private var crossmark: some View {
        VStack {
            Crossmark()
                .trim(from: 0, to: crossMarkPathVisibilityAmount)
                .stroke(
                    Pallete.red,
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .frame(width: 100, height: 100)
                .animation(.easeOut)
            Text("Oops, look's like we can't get response from AppleHealth... Try again later")
                .foregroundColor(Pallete.black)
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.center)
                .opacity(Double(crossMarkPathVisibilityAmount))
                .frame(height: 50)
                .layoutPriority(1)
                .padding()
        }
    }
    
    private var rootContent: some View {
        VStack {
            informativeContent
                .offset(y: viewModel.state == .requested ? 0 : 100)
                .animation(.easeOut)
                .padding()
            ZStack {
                checkmark
                crossmark
            }
            Spacer()
        }
    }
        
    var body: some View {
        GeometryReader { geomery in
            ZStack {
                Pallete.white
                    .cornerRadius(16, corners: .top)
                VStack {
                    rootContent
                    
                    Spacer()
                    ZStack {
                        bottomButtons
                    }
                    .animation(.easeOut)
                }
                .padding()
                .padding(.bottom, geomery.safeAreaInsets.bottom)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onReceive(viewModel.$state, perform: { state in
            if state == .responseReceived(true) {
                withAnimation {
                    self.checkMarkPathVisibilityAmount = 1
                }
            } else if state == .responseReceived(false) {
                withAnimation {
                    self.crossMarkPathVisibilityAmount = 1
                }
            }
        })
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(isShown: .constant(true))
    }
}
