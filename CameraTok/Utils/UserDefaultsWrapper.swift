//
//  UserDefaultsWrapper.swift
//  CameraTok
//
//  Created by Andres Rojas on 15/08/23.
//

import Dependencies
import Foundation

@propertyWrapper
struct UserDefaultsWrapper<Value: Codable> {
    let key: String
    let defaultValue: Value
    @Dependency(\.persistenceService) var persistence

    var wrappedValue: Value {
        get {
            let data = persistence.getData(forKey: key)
            let value = data.flatMap { try? JSONDecoder().decode(Value.self, from: $0) }
            return value ?? defaultValue
        }

        set {
            let data = try? JSONEncoder().encode(newValue)
            persistence.set(data, forKey: key)
        }
    }
}
