//
//  MovieDetailsViewModel.swift
//  MovieFlix
//
//  Created by Sujal on 25/11/2025.
//

import Foundation
import CoreData
import Combine

final class MovieDetailsViewModel: ObservableObject {
    
    @Published var isMovieFavorited: Bool = false
    private let persistence: PersistenceProtocol
    private let context: NSManagedObjectContext
    
    init(
        persistence: PersistenceProtocol = PersistenceManager.shared,
        context: NSManagedObjectContext = PersistenceManager.shared.context
    ) {
        self.persistence = persistence
        self.context = context
    }
    
    func addMovieToFavorite(movieData: Movie) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: "FavoriteMovies",
            in: context
        ) else {
            debugPrint("Failed to get entity description")
            return
        }
        
        let existingMovies: [FavoriteMovies] = persistence.fetchWithPredicate(FavoriteMovies.self, key: "id", with: "\(movieData.id)")
        if existingMovies.isEmpty {
            let movies = FavoriteMovies(entity: entity, insertInto: context)
            movies.id = Int64(movieData.id)
            movies.title = movieData.title
            movies.overview = movieData.overview
            movies.releaseDate = movieData.releaseDate
            movies.posterPath = movieData.posterPath
            movies.backdropPath = movieData.backdropPath
            movies.voteAverage = movieData.voteAverage
            isMovieFavorited = true
        } else {
            for movie in existingMovies {
                persistence.delete(movie)
            }
            isMovieFavorited = false
        }
        
        persistence.save()
    }
    
    func checkIfMovieIsInFavorite(movieData: Movie) {
        let existingMovies: [FavoriteMovies] = persistence.fetchWithPredicate(FavoriteMovies.self, key: "id", with: "\(movieData.id)")
        isMovieFavorited = !existingMovies.isEmpty
    }
}
