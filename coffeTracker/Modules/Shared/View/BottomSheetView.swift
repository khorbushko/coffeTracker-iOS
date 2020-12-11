//
//  BottomView.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 12/11/20.
//

import Foundation
import SwiftUI
import Combine

struct BottomSheetView<Content: View>: View {
    @GestureState private var translation: CGFloat = 0
    @Binding private var openPercentage: CGFloat
    @Binding private var isOpen: Bool
    
    private let isDraggable: Bool
    private let maxHeight: CGFloat
    private let minHeight: CGFloat
    private let content: Content
    
    private var effectiveHeight: CGFloat {
        maxHeight - minHeight
    }
    
    private var offset: CGFloat {
        isOpen ? 0 : effectiveHeight
    }
    
    // MARK: - Lifecycle
    
    init(
        isOpen: Binding<Bool>,
        openPercentage: Binding<CGFloat>,
        isDraggable: Bool = true,
        maxHeight: CGFloat,
        minHeight: CGFloat,
        @ViewBuilder content: () -> Content
    ) {
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
        self._openPercentage = openPercentage
        self.isDraggable = isDraggable
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                content
            }
            .frame(
                width: geometry.size.width,
                height: maxHeight,
                alignment: .top
            )
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: min(max(offset + translation, 0), effectiveHeight))
            .animation(.linear)
            .gesture(
                DragGesture()
                    .updating($translation, body: { (value , state, _) in
                        state = isDraggable ? value.translation.height : state
                        let prc = 1 - (offset + translation) / effectiveHeight
                        
                        // avoid "modification view during update bug"
                        DispatchQueue.main.async {
                            openPercentage = min(max(prc, 0), 1)
                        }
                    })
                    .onEnded({ (value) in
                        isOpen = isDraggable ?
                            value.translation.height < 0 :
                            isOpen
                        DispatchQueue.main.async {
                            openPercentage = isOpen ? 1 : 0
                        }
                    })
            )
        }

        .onReceive(Just(isOpen), perform: { value in
            if translation == 0 {
                openPercentage = value ? 1 : 0
            }
        })
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(
            isOpen: .constant(true),
            openPercentage: .constant(1.0),
            isDraggable: true,
            maxHeight: 700,
            minHeight: 200,
            content: {
                Text("Hello")
            })
    }
}
