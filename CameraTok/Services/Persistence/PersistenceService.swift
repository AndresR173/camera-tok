//
//  PersistenceService.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import Foundation

protocol PersistenceServiceApi {
    func getBool(forKey key: String) -> Bool
    func getData(forKey key: String) -> Data?

    func set(_ value: Any?, forKey key: String)
}

final class PersistenceService: PersistenceServiceApi {
    let defaults = UserDefaults.standard

    func getBool(forKey key: String) -> Bool {
        defaults.bool(forKey: key)
    }

    func getData(forKey key: String) -> Data? {
        defaults.data(forKey: key)
    }

    func set(_ value: Any?, forKey key: String) {
        defaults.setValue(value, forKey: key)
        defaults.synchronize()
    }
}
