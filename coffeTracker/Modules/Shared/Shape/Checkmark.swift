//
//  Checkmark.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 12/11/20.
//

import Foundation
import SwiftUI

struct Checkmark: Shape {
            
    func path(in rect: CGRect) -> Path {
        Path { checkMarkBezierPath in
            let origin = rect.origin
            let diameter = rect.height
            let point1 = CGPoint(x: origin.x + diameter * 0.1, y: origin.y + diameter * 0.4)
            let point2 = CGPoint(x: origin.x + diameter * 0.40, y: origin.y + diameter * 0.7)
            let point3 = CGPoint(x: origin.x + diameter * 0.95, y: origin.y + diameter * 0.2)
            
            checkMarkBezierPath.move(to: point1)
            checkMarkBezierPath.addLine(to: point2)
            checkMarkBezierPath.addLine(to: point3)
        }
    }
}

struct Checkmark_Previews: PreviewProvider {
    
    private struct AnimatedCheckMarkView: View {
        let strokeColor: Color
        @State private var trimAmount: CGFloat = 1
        
        var body: some View {
            Checkmark()
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
        AnimatedCheckMarkView(strokeColor: .green)
    }
}
