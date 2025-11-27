//
//  FavoriteMoviesViewModel.swift
//  MovieFlix
//
//  Created by Sujal on 25/11/2025.
//

import Foundation
import CoreData
import Combine

final class FavoriteMoviesViewModel: ObservableObject {
    
    @Published var favoriteMoviesList: [Movie] = []
    
    func getMovieIsInFavorite() {
        let persistenceManager = PersistenceManager.shared
        let favoriteMovies: [FavoriteMovies] = persistenceManager.fetch(FavoriteMovies.self)
        favoriteMoviesList = favoriteMovies.map { movie in
            Movie(
                id: Int(movie.id),
                title: movie.title ?? "",
                overview: movie.overview ?? "",
                releaseDate: movie.releaseDate ?? "",
                posterPath: movie.posterPath ?? "",
                backdropPath: movie.backdropPath ?? "",
                voteAverage: movie.voteAverage
            )
        }
    }
}
