//
//  Cats.swift
//  CatAPI
//
//  Created by Thayanne Viana on 21/10/21.
//

import Foundation
struct Cats: Codable {
    //    var    adaptability: Int? // Adaptabilidade
    //    var   affectionLevel: Int?// Afeicao
    //    var   childFriendly: Int?// Gosta de criancas
    //    var   countryCode: String?
    //    var   description: String?
    //    var   dogFriendly: Int?// Gosta de cachorros
    //    var   energyLevel: Int? // Nivel de energia
    //    var   experimental: Int?
    //    var   grooming: Int? // Precisa escovar
    //    var   hairless: Int?// Sem pelo
    //    var   healthIssues: Int? // Problemas de saude
    //    var   hypoallergenic: Int? // Nao da alergia
    var   identity: String?
    //    var   image: CatImage?
    //    var   indoor: Int? // Pode viver em apto
    //    var   intelligence: Int? // Inteligente
    //    var   lap: Int? // Gosta de colo
    //    var   lifeSpan: String? // Anos de vida
    //    var   name: String?
    //    var   natural: Int?// Natural ?
    //    var   origin: String?
    //    var   rare: Int? // Raro
    //    var   rex: Int? // https://excitedcats.com/types-of-rex-cats/
    //    var   sheddingLevel: Int? // Solta pelo
    //    var   shortLegs: Int? // Perninha curta
    //    var   socialNeeds: Int? // Necessidade
    //    var   strangerFriendly: Int?  // Amigavelmente estranho
    //    var   suppressedTail: Int? // Rabo pequeno
    //    var   temperament: String? // Temperamentos (varios)
    //    var   vocalisation: Int? // Barulhento
    //    var   weight: CatWeight? // Peso

    enum CodingKeys: String, CodingKey {
        // case weigth
        case identity = "id"
        //    case name
        //    case origin
        //    case country_code = "countryCode"
        //    case description
        //    case life_span = "lifeSpan"
        //    case image
        //    case indoor
        //    case lap
        //    case adaptability
        //    case affection_level = "affectionLevel"
        //    case child_friendly = "childFriendly"
        //    case dog_friendly="dogFriendly"
        //    case energy_level = "energyLevel"
        //    case grooming
        //    case health_issues = "healthIssues"
        //    case intelligence
        //    case shedding_level = "sheddingLevel"
        //    case social_needs = "socialNeeds"
        //    case vocalisation
        //    case experimental
        //    case hairless
        //    case natural
        //    case rare
        //    case rex
        //    case suppressed_tail = "suppressedTail"
        //    case short_legs = "shortLegs"
        //    case hypoallergenic
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
