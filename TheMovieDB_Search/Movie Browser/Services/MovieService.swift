//
//  MovieService.swift
//  Movie Browser
//
//  Created by Khatib Mahad H. on 7/18/21.
//

import Foundation

enum MovieAPI  {
    static let host: String = "api.themoviedb.org"
    static let imageDBBaseUrl: String = "https://image.tmdb.org/t/p/original"
    static let apiKey: String = "2a61185ef6a27f400fd92820ad9e8537"
    enum EndPoints {
        static let searchMovie = "/3/search/movie"
    }
}

protocol MovieService_Protocol {
    func searchMovie(query: String, completion: @escaping (Result<[Movie], Error>) -> Void)
}

class MovieService: MovieService_Protocol {
    
    private let httpManager: HTTPManager
    private let jsonDecoder: JSONDecoder
    
    init(httpManager: HTTPManager = HTTPManager.shared) {
        self.httpManager = httpManager
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    struct MoviesResponseBody: Codable {
            let results: [Movie]
    }
    
    func searchMovie(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = MovieAPI.host
        urlComponents.path = MovieAPI.EndPoints.searchMovie

        let queryItemAPIKey = URLQueryItem(name: "api_key", value: MovieAPI.apiKey)
        let queryItemQuery = URLQueryItem(name: "query", value: query)
        urlComponents.queryItems = [queryItemAPIKey, queryItemQuery]
        
        httpManager.get(urlString: urlComponents.url!.absoluteString) { result in
                switch result {
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            case .success(let data):
                completion(Result(catching: { try self.jsonDecoder.decode(MoviesResponseBody.self, from: data).results }))
            }
        }
    }
}

