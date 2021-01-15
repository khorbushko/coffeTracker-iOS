//
//  Button.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 12/29/20.
//

import Foundation
import SwiftUI

public enum ButtonState {
    case pressed
    case notPressed
}

/// ViewModifier allows us to get a view, then modify it and return it
public struct TouchDownUpEventModifier: ViewModifier {
    
    /// Properties marked with `@GestureState` automatically resets when the gesture ends/is cancelled
    /// for example, once the finger lifts up, this will reset to false
    /// this functionality is handled inside the `.updating` modifier
    @GestureState private var isPressed = false
    
    /// this is the closure that will get passed around.
    /// we will update the ButtonState every time your finger touches down or up.
    let changeState: (ButtonState) -> Void
    
    /// a required function for ViewModifier.
    /// content is the body content of the caller view
    public func body(content: Content) -> some View {
        
        /// declare the drag gesture
        let drag = DragGesture(minimumDistance: 0)
            
            /// this is called whenever the gesture is happening
            /// because we do this on a `DragGesture`, this is called when the finger is down
            .updating($isPressed) { (value, gestureState, transaction) in
                
                /// setting the gestureState will automatically set `$isPressed`
                gestureState = true
            }
        
        return content
            .gesture(drag) /// add the gesture
            .onChange(of: isPressed, perform: { (pressed) in /// call `changeState` whenever the state changes
                /// `onChange` is available in iOS 14 and higher.
                if pressed {
                    self.changeState(.pressed)
                } else {
                    self.changeState(.notPressed)
                }
            })
    }
    
    /// if you're on iPad Swift Playgrounds and you put all of this code in a seperate file,
    /// you need to add a public init so that the compiler detects it.
    public init(changeState: @escaping (ButtonState) -> Void) {
        self.changeState = changeState
    }
}

extension View {
    func touchUpHandle(_ stateHandler: @escaping (ButtonState) -> Void ) -> some View {
        modifier(
            TouchDownUpEventModifier(changeState: { (buttonState) in
                stateHandler(buttonState)
            })
        )
    }
}
