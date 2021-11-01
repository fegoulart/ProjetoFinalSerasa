//
//  FilterBreed.swift
//  CatAPI
//
//  Created by Fernando Goulart on 01/11/21.
//

final class FilterBreed {

    static func getSuggestions(breeds: [Cats], wish: Suggestion) -> [Cats] {
        var suggestion = breeds
        if wish.indoor {
            // indoor esta vindo zero pra todos os gatos
            // vamos usar adaptability
            suggestion = suggestion.filter { $0.adaptability ?? 0 > 3 }
        }
        if wish.vocalize {
            suggestion = suggestion.filter { $0.vocalisation ?? 0 > 3 }
        }
        if wish.lap {
            // lap esta chegando 1 para todos
            // vamos usar affection level
            suggestion = suggestion.filter { $0.affectionLevel ?? 0 > 3 }
        }
        if wish.sociable {
            suggestion = suggestion.filter { $0.socialNeeds ?? 0 > 3 }
        }
        if wish.shedding {
            suggestion = suggestion.filter { $0.sheddingLevel ?? 0 > 3 }
        }
        if wish.rare {
            suggestion = suggestion.filter { $0.rare ?? 0 == 1 }
        }
        return suggestion
    }
}
