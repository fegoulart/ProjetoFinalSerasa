//
//  API.swift
//  CatAPI
//
//  Created by Thayanne Viana on 25/10/21.
//

import Foundation

// FIXME: Alterar para class
struct API {
     let urlRaiz = "https://api.thecatapi.com/"

    /// Returns a URL string with all information about the cats: /v1/breeds
    func setCatBreedsURL() -> String {
        return "\(self.urlRaiz)/\(EndPoints.v1)/\(EndPoints.breeds)"
    }

    func getCats(urlString: String, method: HTTPMethod, response: @escaping ([Cats]) -> Void ) {

    }
}
