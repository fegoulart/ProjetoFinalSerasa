//
//  CatLoader.swift
//  CatLoader
//
//  Created by Fernando Luiz Goulart on 14/11/21.
//

import Foundation

public final class CatLoader: RemoteCatLoader {

    private let url: URL?
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
        case invalidUrl
    }

    public typealias Result = RemoteCatLoader.Result

    public init(
        url: String = "https://api.thecatapi.com/v1/breeds",
        client: HTTPClient = URLSessionHTTPClient(session: URLSession.shared)) {

        self.url = URL(string: url)
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        guard let mUrl = url else {
            completion(Result.failure(Error.invalidUrl))
            return
        }
        do {
            try client.get(from: mUrl) { [weak self] result in
                guard self != nil else {
                    print(self == nil)
                    return
                }

                switch result {
                case let .success((data, response)):

                    completion(CatLoader.map(data, from: response))
                case .failure:
                    completion(.failure(Error.connectivity))
                }
            }
        } catch {
            completion(.failure(Error.connectivity))
        }
    }

    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let catDTO = try CatsMapper.map(data, from: response)
            let cats: [Cat] = catDTO.toModels()
            return .success(cats)
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == CatDTO {
    func toModels() -> [Cat] {

        return map {
           Cat(
            adaptability: $0.adaptability,
            hypoallergenic: $0.hypoallergenic,
            identity: $0.identity,
            imageUrl: $0.image?.url,
            indoor: $0.indoor,
            intelligence: $0.intelligence,
            lap: $0.lap,
            lifeSpan: $0.lifeSpan,
            name: $0.name,
            natural: $0.natural,
            origin: $0.origin,
            rare: $0.rare,
            rex: $0.rex,
            sheddingLevel: $0.sheddingLevel,
            shortLegs: $0.shortLegs,
            socialNeeds: $0.socialNeeds,
            strangerFriendly: $0.strangerFriendly,
            suppressedTail: $0.suppressedTail,
            temperament: $0.temperament,
            vocalisation: $0.vocalisation,
            weight: $0.weight?.weight?.metric,
            affectionLevel: $0.affectionLevel,
            catDescription: $0.catDescription)
        }
    }
}
