//
//  API.swift
//  CatAPI
//
//  Created by Thayanne Viana on 25/10/21.
//

import Foundation

class API {
     let urlRaiz = "https://api.thecatapi.com/v1"

    /// Returns a URL string with all information about the cats: /v1/breeds
    func setCatBreedsURL() -> String {
        return "\(self.urlRaiz)/\(EndPoints.breeds)"
    }

    func getCats(urlString: String, method: HTTPMethod, response: @escaping ([Cats]) -> Void, errorReturned: @escaping (String) -> Void ) {
        
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: config)
                
        guard let url: URL = URL(string: urlString) else { return }
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "\(method)"
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (result, urlResponse, error) in
                var statusCode: Int = 0
                   
                if let response = urlResponse as? HTTPURLResponse {
                    statusCode = response.statusCode
                   }
                   
                guard let data = result else {
                       
                    errorReturned("Não retornou nada")
                       return
                   }
                   
                   do {
                       
                    let decoder = JSONDecoder()
                    let decodableData: [Cats] = try decoder.decode([Cats].self, from: data)
                    if decodableData.count < 1 {
                           errorReturned("Array de gatos é igual a ZERO")
                       }
                       
                    switch statusCode {
                    case 200:
                        response(decodableData)
                    case 404:
                        errorReturned("Página não encontrada")
                        return
                    case 500:
                        errorReturned("Erro do servidor")
                        return
                    default:
                        break
                       }
                       
                   } catch {
                       errorReturned("Impossível decodificar")
                   }
               })
               task.resume()
           }

    }

