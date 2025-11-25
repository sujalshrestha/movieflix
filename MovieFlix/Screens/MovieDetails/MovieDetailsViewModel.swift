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
    
    func addMovieToFavorite(movieData: Movie) {
        let persistenceManager = PersistenceManager.shared
        guard let entity = NSEntityDescription.entity(
            forEntityName: "FavoriteMovies",
            in: persistenceManager.context
        ) else {
            debugPrint("Failed to get entity description")
            return
        }
        
        let existingMovies: [FavoriteMovies] = persistenceManager.fetchWithPredicate(FavoriteMovies.self, key: "id", with: "\(movieData.id)")
        if existingMovies.isEmpty {
            let movies = FavoriteMovies(entity: entity, insertInto: persistenceManager.context)
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
                persistenceManager.delete(movie)
            }
            isMovieFavorited = false
        }
        
        persistenceManager.save()
    }
    
    func checkIfMovieIsInFavorite(movieData: Movie) {
        let persistenceManager = PersistenceManager.shared
        let existingMovies: [FavoriteMovies] = persistenceManager.fetchWithPredicate(FavoriteMovies.self, key: "id", with: "\(movieData.id)")
        isMovieFavorited = !existingMovies.isEmpty
    }
}
