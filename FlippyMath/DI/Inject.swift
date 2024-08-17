//
//  Inject.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import Swinject

@propertyWrapper
struct Inject<T> {
    private let container: Container
    private var storedValue: T?
    private var name: String? = nil

    init(name: String? = nil, container: Container = .AppContainer) {
        self.container = container
        self.storedValue = container.resolve(T.self, name: name)
        self.name = name
    }

    var wrappedValue: T {
        get {
            let resolved = storedValue ?? container.resolve(T.self, name: name)
            assert(resolved != nil, "Dependency not found: \(String(describing: T.self))")
            return resolved!
        }
        set {
            storedValue = newValue
        }
    }
}
