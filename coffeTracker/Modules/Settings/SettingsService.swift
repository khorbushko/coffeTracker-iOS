//
//  SettingsService.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/15/21.
//

import Foundation

enum SettingsDataKeys {
    static let isVibroEnabled = "isVibroEnabled"

}

protocol SettingsService: class {
    var didChange: NSNotification.Name { get }
    
    var isVibroEnabled: Bool { get set }
}
