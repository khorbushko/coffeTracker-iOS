//
//  KeyedDecodingContainer.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 1/8/21.
//

import Foundation

public extension KeyedDecodingContainer {
    
    func decode<T: Decodable>(_ key: Key, as type: T.Type = T.self) throws -> T {
        return try self.decode(T.self, forKey: key)
    }
    
    func decodeIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }
}
