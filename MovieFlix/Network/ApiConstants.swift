//
//  ApiConstants.swift
//  MovieFlix
//
//  Created by Sujal on 24/11/2025.
//

import Foundation

struct ApiConstants {
    static let baseUrl = "https://api.themoviedb.org/"
    static let version = "3/"
    static let fullBaseUrl = Self.baseUrl + Self.version
    static let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhM2VlZjk0ZmFkMDFkNDI2ODAzMzI3MWIyODRlMjNmNCIsIm5iZiI6MTUzNDMwNDU0OC4xNTYsInN1YiI6IjViNzNhMTI0MGUwYTI2N2VlNzFkNDM0ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.U54qCMm36nMoquva4SCj2iqkeDA7ahu8CUnJK4OieZM"
    
    static let movieSearch = "search/movie"
}
