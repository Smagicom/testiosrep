//
//  NetworkManager.swift
//  MovieDB
//
//  Created by adminIL on 02.07.2024.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private lazy var urlComponent:URLComponents = {
        var component = URLComponents()
        component.host = "api.themoviedb.org"
        component.scheme = "https"
        component.queryItems = [
            URLQueryItem(name: "api_key", value: "d351d913d674bd98da28dea154905f25")
        ]
        
        return component
    }()
    
    func loadMovie(complition: @escaping ([Result]) -> Void) {
        urlComponent.path = "/3/movie/now_playing"
        guard let url = urlComponent.url else {return}
        let session = URLSession(configuration: .default)
        DispatchQueue.global().async {
            let task = session.dataTask(with: url) { data,response,error in
                guard let data = data else {return}
                if let movie = try? JSONDecoder().decode(Movie.self, from: data) {
                    DispatchQueue.main.async {
                        complition(movie.results!)
                    }
                }
             
                
            }
            task.resume()
        }
    }
    
    func loadMovieDetail(movieID:Int, complition: @escaping (MovieDetail)->Void)
    {
        urlComponent.path = "/3/movie/\(movieID)"
        guard let url = urlComponent.url else {return}
        let session = URLSession(configuration: .default)
        DispatchQueue.global().async {
           session.dataTask(with: url) {
                data,response,error in
                guard let data else {return}
                guard let movie = try? JSONDecoder().decode(MovieDetail.self, from: data) else {return}
                DispatchQueue.main.async {
                    complition(movie)
                }
                
            }.resume()
        }
    }

    func loadImage() {
        
    }
}
