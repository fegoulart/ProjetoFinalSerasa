//
//  Cats.swift
//  CatAPI
//
//  Created by Thayanne Viana on 21/10/21.
//

import Foundation
//class CatMapper{
//    // static func map(var catDTO) -> Cat{
//
//}

// mapeamento da API
struct Cats: Codable {
    let temperament: String?
    let weigth: Weight?
    let id: String?
    let name: String?
    let cfa_url: String?
    let vetstreet_url: String?
    let vcahospitals_url: String?
    let origin: String?
    let country_code: String?
    let country_codes: String?
    let description: String?
    let life_span: String?
    let wikipediaUrl: String?
    let reference_image_id: String?
    let image: Image?
    let indoor: Int?
    let lap: Int?
    let alt_names: String?
    let adaptability: Int?
    let affection_level: Int?
    let child_friendly: Int?
    let dog_friendly: Int?
    let energy_level: Int?
    let grooming: Int?
    let health_issues: Int?
    let intelligence: Int?
    let shedding_level: Int?
    let social_needs: Int?
    let vocalisation: Int?
    let experimental: Int?
    let hairless: Int?
    let natural: Int?
    let rare: Int?
    let rex: Int?
    let suppressed_tail: Int?
    let short_legs: Int?
    let hypoallergenic: Int?
    var stranger_friendly: Int?

}

struct Image: Codable{
    var height: Int?
    var id: String?
    var url: String?
    var width: Int?
}

struct Weight: Codable{
    var imperial: String?
    var metric: String?
}

struct Cat: Codable{
    var catDetail: [Cats]?
}






//enum CodingKeys: String, CodingKey {
//    case weigth = "peso"
//    case id = "id"
//    case name = "nome"
//    case cafUrl
//    case vetstreetUrl
//    case vcahospitalsUrl
//    case origin = "origem"
//    case countryCode = "codigodoPais"
//    case description = "descricao"
//    case lifeSpan = "vidaUtil"
//    case wikipediaUrl
//    case referenceImageId
//    case image
//    case indoor
//    case lap
//    case altNames
//    case adaptability
//    case affectionLevel
//    case childFriendly
//    case dogFriendly
//    case energyLevel
//    case grooming
//    case healthIssues
//    case intelligence
//    case sheddingLevel
//    case socialNeeds
//    case vocalisation
//    case experimental
//    case hairless
//    case natural
//    case rare
//    case rex
//    case suppressedTail
//    case shortLegs
//    case hypoallergenic
//}
