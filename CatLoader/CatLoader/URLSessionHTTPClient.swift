//
//  URLSessionHTTPClient.swift
//  CatLoader
//
//  Created by Fernando Luiz Goulart on 14/11/21.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    private struct UnexpectedValuesRepresentation: Error {}
    public struct CouldNotInitializeURLRequest: Error {}

    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) throws {

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let componentsURL = components.url else {
            throw CouldNotInitializeURLRequest()
        }
        let request = URLRequest(url: componentsURL)

        session.dataTask(with: request) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }.resume()
    }
}
