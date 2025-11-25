//
//  SearchViewModel.swift
//  MovieFlix
//
//  Created by Sujal on 24/11/2025.
//

import Foundation
import Combine
import CoreData

final class SearchViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var movieData: [Movie] = []
    @Published var onApiError: (isError: Bool, message: String) = (false, "")
    
    private var currentPage = 1
    private var totalPages = 1
    private var currentSearchText = ""
    
    func getMoviesList(for searchText: String, reset: Bool = true) {
        let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchText
        
        if reset { resetPageData(searchText: searchText) }
        
        guard currentPage <= totalPages else { return }
        
        let request = MovieRouter.searchMovie(query: encodedSearchText, page: currentPage)
        isLoading = true
        
        NetworkManager.shared.execute(urlRequest: request, model: MovieSearchResponse.self) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let response):
                movieData.append(contentsOf: response.results)
                currentPage += 1
                totalPages = response.totalPages
                saveMoviesLocally(movieArray: response.results)
                
            case .failure(let error):
                debugPrint("Error: ", error)
                self.onApiError = (true, error.message)
            }
        }
    }
    
    private func resetPageData(searchText: String) {
        currentPage = 1
        totalPages = 1
        movieData = []
        currentSearchText = searchText
    }
    
    func loadMoreIfNeeded(currentItem item: Movie) {
        guard let last = movieData.last else { return }
        if last.id == item.id && currentPage <= totalPages && !isLoading {
            getMoviesList(for: currentSearchText, reset: false)
        }
    }
    
    private func saveMoviesLocally(movieArray: [Movie]) {
        let persistenceManager = PersistenceManager.shared
        guard let entity = NSEntityDescription.entity(
            forEntityName: "Movies",
            in: persistenceManager.context
        ) else {
            debugPrint("Failed to get entity description")
            return
        }
        
        for movieData in movieArray {
            let existingMovies: [Movies] = persistenceManager.fetchWithPredicate(Movies.self, key: "id", with: "\(movieData.id)")
            if existingMovies.isEmpty {
                let movies = Movies(entity: entity, insertInto: persistenceManager.context)
                movies.id = Int64(movieData.id)
                movies.title = movieData.title
                movies.overview = movieData.overview
                movies.releaseDate = movieData.releaseDate
                movies.posterPath = movieData.posterPath
                movies.backdropPath = movieData.backdropPath
                movies.voteAverage = movieData.voteAverage
            }
        }
        
        persistenceManager.save()
    }
    
    func getSavedMovies() {
        let savedMoviesArray = PersistenceManager.shared.fetch(Movies.self)
        if savedMoviesArray.isEmpty { return }
        var movieArray = [Movie]()
        for savedMoviesData in savedMoviesArray {
            movieArray.append(
                Movie(
                    id: Int(savedMoviesData.id),
                    title: savedMoviesData.title ?? "",
                    overview: savedMoviesData.overview ?? "",
                    releaseDate: savedMoviesData.releaseDate ?? "",
                    posterPath: savedMoviesData.posterPath ?? "",
                    backdropPath: savedMoviesData.backdropPath ?? "",
                    voteAverage: savedMoviesData.voteAverage
                )
            )
        }
        self.movieData = movieArray
    }
}
