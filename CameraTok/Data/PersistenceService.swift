//
//  PersistenceService.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import Foundation

protocol PersistenceServiceApi {
    func getString(forKey key: String) -> String?
    func getBool(forKey key: String) -> Bool
    func getArray(forKey key: String) -> [Any]?
    func getDict(forKey key: String) -> [String: Any]?

    func set(_ value: Any, forKey key: String)
}

final class PersistenceService: PersistenceServiceApi {
    let defaults = UserDefaults.standard

    func getString(forKey key: String) -> String? {
        defaults.string(forKey: key)
    }

    func getBool(forKey key: String) -> Bool {
        defaults.bool(forKey: key)
    }

    func getArray(forKey key: String) -> [Any]? {
        defaults.array(forKey: key)
    }

    func getDict(forKey key: String) -> [String: Any]? {
        defaults.dictionary(forKey: key)
    }

    func set(_ value: Any, forKey key: String) {
        defaults.setValue(value, forKey: key)
    }
}
