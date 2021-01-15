//
//  Binding+Constant.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/8/21.
//  https://www.swiftbysundell.com/articles/getting-the-most-out-of-xcode-previews/

import Foundation
import SwiftUI

extension Binding {
    static func mock(_ value: Value) -> Self {
        var value = value
        return Binding(get: { value }, set: { value = $0 })
    }
}
