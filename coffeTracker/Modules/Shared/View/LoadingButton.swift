//
//  CheckBoxView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 12/11/20.
//

import Foundation
import SwiftUI

struct LoadingButton: View {
    
    @Binding var loading: Bool

    let foregroundColor: Color
    let backgroundColor: Color
    let action: () -> Void
    let label: Text
    
    var body: some View {
        Button(
            action: {
                withAnimation {
                    loading = true
                }
                action()
            },
            label: {
                HStack {
                    loading ?
                        Text("") :
                        label
                }
                .frame(
                    maxWidth: loading ? 55 : .infinity,
                    maxHeight: .infinity
                )
            }
        )
        
        .contentShape(Rectangle())
        .frame(minWidth: 0, maxWidth: loading ? 55 : .infinity)
        .font(.system(size: 17, weight: .semibold))
        .frame(height: 55)
        .foregroundColor(foregroundColor)
        .background(backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(backgroundColor, lineWidth: 2)
                .overlay(
                    ActivityView()
                        
                        .foregroundColor(foregroundColor)
                        .opacity(loading ? 1 : 0)
                        .scaleEffect(0.75)
                        .animation(.default)
                )
        )
        .cornerRadius(8)
    }
}

struct CheckboxView_Previews: PreviewProvider {
    
    private struct TestView: View {
        @State private var isLoading: Bool = false
        
        var body: some View {
            LoadingButton(
                loading: $isLoading,
                foregroundColor: Color.white,
                backgroundColor: Color.blue,
                action: {
                    
                },
                label: Text("Next")
            )
            .padding()
        }
    }
    
    static var previews: some View {
        TestView()
    }
}
