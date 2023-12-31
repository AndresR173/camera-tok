//
//  PersistenceService+Dependencies.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import Dependencies
import Foundation

enum PersistenceServiceDependencyKey: DependencyKey {
    static let liveValue: PersistenceServiceApi = PersistenceService()
    static let previewValue: PersistenceServiceApi = MockPersistenceService()
    static let testValue: PersistenceServiceApi = MockPersistenceService()

    class MockPersistenceService: PersistenceServiceApi {
        var container: [String: Any] = [:]

        func getBool(forKey key: String) -> Bool {
            container[key] as? Bool ?? false
        }

        func getData(forKey key: String) -> Data? {
            container[key] as? Data
        }

        func set(_ value: Any?, forKey key: String) {
            container[key] = value
        }
    }
}

extension DependencyValues {
    var persistenceService: PersistenceServiceApi {
        get { self[PersistenceServiceDependencyKey.self] }
        set { self[PersistenceServiceDependencyKey.self] = newValue }
    }
}
