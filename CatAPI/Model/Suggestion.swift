//
//  Suggestion.swift
//  CatAPI
//
//

import Foundation

public struct Suggestion {
    public let indoor: Bool
    public let vocalize: Bool
    public let lap: Bool
    public let sociable: Bool
    public let shedding: Bool
    public let rare: Bool

    public init(
        indoor: Bool,
        vocalize: Bool,
        lap: Bool,
        sociable: Bool,
        shedding: Bool,
        rare: Bool
    ) {
        self.indoor = indoor
        self.vocalize = vocalize
        self.lap = lap
        self.sociable = sociable
        self.shedding = shedding
        self.rare = rare
    }
}
