//
//  ErrorAPI.swift
//  CatAPI
//
//  Created by Fernando Goulart on 02/11/21.
//

enum ErrorAPI: Error {
    case noURL
    case decodeFailed
    case noData
    case serverError
    case wrongStatusCode
    case notFound
    case connectivity
}
