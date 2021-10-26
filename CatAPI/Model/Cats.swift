//
//  Cats.swift
//  CatAPI
//
//  Created by Thayanne Viana on 21/10/21.
//

import Foundation
class CatMapper{
    // static func map(var catDTO) -> Cat{
    
}
// FIXME: Os dois pontos deveriam ficar próximos da variável
// FIXME: Remover as variaveis com underscore (_) e usar camelCase com CodingKeys
struct Cats: Codable{
    var temperament        : Temperament?
    var weigth             : String?
    var id                 : String?
    var name               : String?
    var caf_url            : String?
    var vetstreet_url      : String?
    var vcahospitals_url   : String?
    var origin             : String?
    var country_code       : String?
    var description        : String?
    var life_span          : String?
    var wikipedia_url      : String?
    var reference_image_id : String?
    var image              : String?
    var indoor             : Bool?
    var lap                : Bool?
    var alt_names          : Bool?
    var adaptability       : Bool?
    var affection_level    : Bool?
    var child_friendly     : Bool?
    var dog_friendly       : Bool?
    var energy_level       : Bool?
    var grooming           : Bool?
    var health_issues      : Bool?
    var intelligence       : Bool?
    var shedding_level     : Bool?
    var social_needs       : Bool?
    var vocalisation       : Bool?
    var experimental       : Bool?
    var hairless           : Bool?
    var natural            : Bool?
    var rare               : Bool?
    var rex                : Bool?
    var suppressed_tail    : Bool?
    var short_legs         : Bool?
    var hypoallergenic     : Bool?
    // FIXME: Remover espacos (instalar Swiflint)
     
    
    
    
}

// FIXME: Corrigir os dois pontos
struct Temperament: Codable {
    
    var active            : Bool?
    var energetic         : Bool?
    var independent       : Bool?
    var intelligent       : Bool?
    var gentl             : Bool?
    var affectionate      : Bool?
    var social            : Bool?
    var playful           : Bool?
    var interactive       : Bool?
    var lively            : Bool?
    var sensitiv          : Bool?
    var curious           : Bool?
    var easyGoing         : Bool?
    var calm              : Bool?
    var loyal             : Bool?
    var sensible          : Bool?
    var agile             : Bool?
    var funLoving         : Bool?
    var relaxed           : Bool?
    var friendly          : Bool?
    var alert             : Bool?
    var demanding         : Bool?
    var dependent         : Bool?
    var patient           : Bool?
    var highlyInteractive : Bool?
    var mischievous       : Bool?
    var loving            : Bool?
    var sweet             : Bool?
    var quiet             : Bool?
    var clever            : Bool?
    var devoted           : Bool?
    var talkative         : Bool?
    var warm              : Bool?
    var highlyIntelligent : Bool?
    var expressive        : Bool?
    var trainable         : Bool?
    var inquisitive       : Bool?
    var sociable          : Bool?
    var shy               : Bool?
    var sedate            : Bool?
    var outgoing          : Bool?
    var adventurous       : Bool?
    var sweetTempered     : Bool?
    var tenacious         : Bool?


    
}
