//
//  MovieModel.swift
//  MovieFlix
//
//  Created by Sujal on 24/11/2025.
//

import Foundation

struct Movie: DataModel, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String
    let backdropPath: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
    }
    
    init(
        id: Int,
        title: String,
        overview: String,
        releaseDate: String,
        posterPath: String,
        backdropPath: String,
        voteAverage: Double
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.voteAverage = voteAverage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? ""
        
        let vote = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0
        voteAverage = vote.rounded(to: 2)
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
