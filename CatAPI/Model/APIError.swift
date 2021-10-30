//
//  APIError.swift
//  CatAPI
//
//  Created by Thayanne Viana on 30/10/21.
//

import Foundation
enum APIError: Error{
    case connectivity
    case notFound
    case empty
    case invalidJSON
    case serverError
    case noData
}
