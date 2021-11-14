//
//  CatMapper.swift
//  CatLoader
//
//  Created by Fernando Luiz Goulart on 14/11/21.
//

import Foundation

final class CatsMapper {

    private static var OK200: Int { return 200 }

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [CatDTO] {
        guard response.statusCode == OK200,
              let catDTO = try? JSONDecoder().decode([CatDTO].self, from: data) else {
            throw CatLoader.Error.invalidData
        }

        return catDTO
    }
}
