//
//  CatDTO.swift
//  CatLoader
//
//  Created by Fernando Luiz Goulart on 14/11/21.
//

struct CatDTO: Codable {
    var adaptability: Int? // Adaptabilidade
    var hypoallergenic: Int? // Nao da alergia
    var identity: String?
    var image: CatImage?
    var indoor: Int? // Pode viver em apto
    var intelligence: Int? // Inteligente
    var lap: Int? // Gosta de colo
    var lifeSpan: String? // Anos de vida
    var name: String?
    var natural: Int?// Natural ?
    var origin: String?
    var rare: Int? // Raro
    var rex: Int? // https://excitedcats.com/types-of-rex-cats/
    var sheddingLevel: Int? // Solta pelo
    var shortLegs: Int? // Perninha curta
    var socialNeeds: Int? // Necessidade
    var strangerFriendly: Int?  // Amigavelmente estranho
    var suppressedTail: Int? // Rabo pequeno
    var temperament: String? // Temperamentos (varios)
    var vocalisation: Int? // Barulhento
    var weight: CatWeight? // Peso
    var affectionLevel: Int?
    var catDescription: String?

    enum CodingKeys: String, CodingKey {
        case weight
        case identity = "id"
        case name
        case origin
        case catDescription = "description"
        case lifeSpan = "life_span"
        case image
        case indoor
        case lap
        case adaptability
        case affectionLevel = "affection_level"
        case intelligence
        case sheddingLevel = "shedding_level"
        case vocalisation
        case natural
        case rare
        case rex
        case suppressedTail = "suppressed_tail"
        case shortLegs = "short_legs"
        case socialNeeds = "social_needs"
        case hypoallergenic
        case strangerFriendly
        case temperament
    }
}
struct CatImage: Codable {
    var url: String?
}
struct CatWeight: Codable {
    var weight: MetricWeight?
}
struct MetricWeight: Codable {
    var metric: String?
}
