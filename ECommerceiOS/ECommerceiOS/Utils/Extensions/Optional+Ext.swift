//
//  Optional+Ext.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

import Foundation

extension Optional where Wrapped == String {
    var orEmpty: String { self ?? "" }
}

extension Optional where Wrapped == Int {
    var orZero: Int { self ?? 0 }
}

extension Optional where Wrapped == Int64 {
    var orZero: Int64 { self ?? 0 }
}

extension Optional where Wrapped == Double {
    var orZero: Double { self ?? 0.0 }
}

extension Optional where Wrapped == Float {
    var orZero: Float { self ?? 0.0 }
}

extension Optional where Wrapped == Bool {
    var orFalse: Bool { self ?? false }
}
