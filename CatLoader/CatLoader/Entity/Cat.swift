//
//  Cat.swift
//  CatLoader
//
//  Created by Fernando Luiz Goulart on 14/11/21.
//

public struct Cat: Equatable {
    public var adaptability: Int?
    public var hypoallergenic: Int?
    public var identity: String?
    public var imageUrl: String?
    public var indoor: Int?
    public var intelligence: Int?
    public var lap: Int?
    public var lifeSpan: String?
    public var name: String?
    public var natural: Int?
    public var origin: String?
    public var rare: Int?
    public var rex: Int?
    public var sheddingLevel: Int?
    public var shortLegs: Int?
    public var socialNeeds: Int?
    public var strangerFriendly: Int?
    public var suppressedTail: Int?
    public var temperament: String?
    public var vocalisation: Int?
    public var weight: String?
    public var affectionLevel: Int?
    public var catDescription: String?

    public init(
        adaptability: Int?,
        hypoallergenic: Int?,
        identity: String?,
        imageUrl: String?,
        indoor: Int?,
        intelligence: Int?,
        lap: Int?,
        lifeSpan: String?,
        name: String?,
        natural: Int?,
        origin: String?,
        rare: Int?,
        rex: Int?,
        sheddingLevel: Int?,
        shortLegs: Int?,
        socialNeeds: Int?,
        strangerFriendly: Int?,
        suppressedTail: Int?,
        temperament: String?,
        vocalisation: Int?,
        weight: String?,
        affectionLevel: Int?,
        catDescription: String?
    ) {
        self.adaptability = adaptability
        self.hypoallergenic = hypoallergenic
        self.identity = identity
        self.imageUrl = imageUrl
        self.indoor = indoor
        self.intelligence = intelligence
        self.lap = lap
        self.lifeSpan = lifeSpan
        self.name = name
        self.natural = natural
        self.origin = origin
        self.rare = rare
        self.rex = rex
        self.sheddingLevel = sheddingLevel
        self.shortLegs = shortLegs
        self.socialNeeds = socialNeeds
        self.strangerFriendly = strangerFriendly
        self.suppressedTail = suppressedTail
        self.temperament = temperament
        self.vocalisation = vocalisation
        self.weight = weight
        self.affectionLevel = affectionLevel
        self.catDescription = catDescription
    }
}
