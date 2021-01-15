//
//  SettingsView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 11/30/20.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @ObservedObject private var viewModel: SettingsViewModel
    
    @ViewBuilder
    private var hapticSection: some View {
        Section(
            header: HStack {
                Text("System")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Pallete.black)
                Spacer()
            }
            .frame(height: 38)
            .padding(.horizontal, 16),
            footer: HStack {
                Text("Some controls will vibrate the phone when tapped")
                    .font(.system(size: 11))
                    .foregroundColor(Pallete.black.opacity(0.5))
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(.horizontal, 16)
        ) {
            Divider().padding(.trailing, -16)
            
            Toggle(isOn: $viewModel.isVibroEnabled) {
                HStack {
                    Image("ic_settings_vibro")
                        .frame(width: 50)
                    Text("Vibrate on Tap")
                        .font(.system(size: 17))
                        .foregroundColor(Pallete.black)
                }
            }
            .frame(height: 44)
            
        }
        .padding(.horizontal, 16)
        .background(Pallete.white)
    }
    
    // MARK: - LifeCycle
    
    init(storage: SettingsService) {
        viewModel = SettingsViewModel(storage: storage)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView {
                        hapticSection
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: Pallete.brown))
            }
            .padding(.top, 1)
            .mask(Rectangle())
            .navigationBarTitle(Text("Settings"))
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(storage: UserDefaults.standard)
    }
}
