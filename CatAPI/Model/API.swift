//
//  API.swift
//  CatAPI
//
//  Created by Thayanne Viana on 25/10/21.
//

import Foundation

class API {
    let urlRaiz = "https://api.thecatapi.com/v1"
    let key = "5b81680c-1d66-40b0-846f-d32b34f17507"

    /// Returns a URL string with all information about the cats: /v1/breeds
    func setCatBreedsURL() -> String {
        return "\(self.urlRaiz)/\(EndPoints.breeds)"
    }

    func getCats(
        urlString: String,
        method: HTTPMethod,
        completion: @escaping ((Result < [Cats], APIError>) -> Void)
    ) {

        let config: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: config)

        guard let url: URL = URL(string: urlString) else { return }
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "\(method)"
        urlRequest.setValue(key, forHTTPHeaderField: "x-api-key")
        let task = session.dataTask(with: urlRequest, completionHandler: { (result, urlResponse, _) in
            var statusCode: Int = 0

            if let response = urlResponse as? HTTPURLResponse {
                statusCode = response.statusCode
            }

            guard let data = result else {

                completion(Result.failure(APIError.noData))
                return
            }

            do {

                let decoder = JSONDecoder()
                let decodableData: [Cats] = try decoder.decode([Cats].self, from: data)
                if decodableData.count < 1 {
                    completion(Result.failure(APIError.empty))
                }

                switch statusCode {
                case 200:
                    completion(Result.success(decodableData))
                case 404:
                    completion(Result.failure(APIError.notFound))
                    return
                case 500:
                    completion(Result.failure(APIError.serverError))
                    return
                default:
                    completion(Result.failure(APIError.connectivity))
                }
            } catch {
                completion(Result.failure(APIError.invalidJSON))
            }
        })
        task.resume()
    }

}
