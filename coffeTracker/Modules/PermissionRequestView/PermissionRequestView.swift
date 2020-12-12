//
//  IntroView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 11/30/20.
//

import Foundation
import SwiftUI
import Combine

struct PermissionRequestView: View {
    @Binding var isShown: Bool
    @Namespace private var introNamespace
    @ObservedObject private var viewModel: PermissionRequestViewModel
    @State private var checkMarkPathVisibilityAmount: CGFloat = 0
    @State private var crossMarkPathVisibilityAmount: CGFloat = 0

    init(isShown: Binding<Bool>) {
        _isShown = isShown
        let storage = EnvironmentValueStorage()
        viewModel = PermissionRequestViewModel(healthStore: storage.healthStore)
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
    
    private var bottomButton: some View {
        LoadingButton(
            loading: .constant(viewModel.state == .requested),
            foregroundColor: Pallete.white,
            backgroundColor: Pallete.brown,
            action: {
                if viewModel.state.isResponseReceived {
                    isShown = false
                } else {
                    viewModel.perform(.next)
                }
            },
            label: Text(
                viewModel.state.isResponseReceived ?
                    "Let me drink the coffee!" :
                    "Next"
            )
        )
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
                        bottomButton
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
        PermissionRequestView(isShown: .constant(true))
    }
}
