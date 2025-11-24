//
//  MovieModel.swift
//  MovieFlix
//
//  Created by Sujal on 24/11/2025.
//

import Foundation

struct Movie: DataModel, Identifiable {
    let id: Int?
    let title: String?
    let overview: String?
    let releaseDate: String?
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}

struct MovieSearchResponse: DataModel {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
