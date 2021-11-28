//
//  CustomOperators.swift
//  CatAPI
//
//  Created by Fernando Luiz Goulart on 23/11/21.
//

import Foundation

infix operator ???:NilCoalescingPrecedence

public func ??? <T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    switch optional {
    case let value?: return String(describing: value)
    case nil: return defaultValue()
    }
}
