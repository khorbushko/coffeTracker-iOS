//
//  Cross.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 12/11/20.
//

import Foundation
import SwiftUI

struct Crossmark: Shape {
    func path(in rect: CGRect) -> Path {
        Path { crossMarkPath in
            let origin = rect.origin
            let diameter = rect.height
            
            let startPointForFirstLine = CGPoint(x: origin.x + diameter * 0.25, y: origin.y + diameter * 0.25)
            let endPointForFirstLine = CGPoint(x: origin.x + diameter * 0.75, y: origin.y + diameter * 0.75)
            
            let startPointForSecondLine = CGPoint(x: origin.x + diameter * 0.75, y: origin.y + diameter * 0.25)
            let endPointForSecondLine = CGPoint(x: origin.x + diameter * 0.25, y: origin.y + diameter * 0.75)
            
            crossMarkPath.move(to: startPointForFirstLine)
            crossMarkPath.addLine(to: endPointForFirstLine)
            crossMarkPath.move(to: endPointForSecondLine)
            crossMarkPath.addLine(to: startPointForSecondLine)
        }
    }
}

struct Crossmark_Previews: PreviewProvider {
    
    private struct AnimatedCrossMarkView: View {
        let strokeColor: Color
        @State private var trimAmount: CGFloat = 1
        
        var body: some View {
            Crossmark()
                .trim(from: 0, to: trimAmount)
                .stroke(
                    strokeColor,
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .frame(width: 100, height: 100)
                .animation(.easeOut)
                .onTapGesture {
                    self.trimAmount = .random(in: 10...90) / 100.0
                }
        }
    }
    
    static var previews: some View {
        AnimatedCrossMarkView(strokeColor: .red)
    }
}
