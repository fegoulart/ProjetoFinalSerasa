//
//  API.swift
//  CatAPI
//
//  Created by Thayanne Viana on 25/10/21.
//

import Foundation
struct API{
     let urlRaiz = "https://api.thecatapi.com/"
    
    ///Returns a URL string with all information about the cats: /v1/breeds
    func setCatBreedsURL() -> String {
        return "\(self.urlRaiz)/\(EndPoints.v1)/\(EndPoints.breeds)"
    }
    
    func getCats(urlString: String, method: HTTPMethod, response: ([Cats]) -> Void ) {
        
    }
}
 

