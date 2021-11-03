//
//  ErrorAPI.swift
//  CatAPI
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
