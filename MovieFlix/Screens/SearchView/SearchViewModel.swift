//
//  SearchViewModel.swift
//  MovieFlix
//
//  Created by Sujal on 24/11/2025.
//

import Foundation
import Combine
import CoreData

@MainActor
final class SearchViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var movieData: [Movie] = []
    @Published var onApiError: (isError: Bool, message: String) = (false, "")
    @Published var favoriteMoviesCount: Int = 0
    
    private var currentPage = 1
    private var totalPages = 1
    private var currentSearchText = ""
    
    var currentPageValue: Int { currentPage }
    
    // MARK: - Injected Dependencies
    private let network: NetworkServiceProtocol
    private let persistence: PersistenceProtocol
    private let context: NSManagedObjectContext
    
    init(
        network: NetworkServiceProtocol,
        persistence: PersistenceProtocol,
        context: NSManagedObjectContext
    ) {
        self.network = network
        self.persistence = persistence
        self.context = context
    }

    convenience init() {
        self.init(
            network: NetworkManager.shared,
            persistence: PersistenceManager.shared,
            context: PersistenceManager.shared.context
        )
    }
    
    func getMoviesList(for searchText: String, reset: Bool = true) async {
        let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchText
        
        if reset { resetPageData(searchText: searchText) }
        
        guard currentPage <= totalPages else { return }
        
        let request = MovieRouter.searchMovie(query: encodedSearchText, page: currentPage)
        isLoading = true

        defer { isLoading = false }

        do {
            let response: MovieSearchResponse = try await network.execute(urlRequest: request, request: nil)
            movieData.append(contentsOf: response.results)
            currentPage += 1
            totalPages = response.totalPages
            saveMoviesLocally(movieArray: response.results)
        } catch let error as NetworkError {
            debugPrint("Error: ", error)
            onApiError = (true, error.message)
        } catch {
            debugPrint("Error: ", error)
            onApiError = (true, NetworkError.unknown.message)
        }
    }
    
    private func resetPageData(searchText: String) {
        currentPage = 1
        totalPages = 1
        movieData = []
        currentSearchText = searchText
    }
    
    func loadMoreIfNeeded(currentItem item: Movie) async {
        guard let last = movieData.last else { return }
        if last.id == item.id && currentPage <= totalPages && !isLoading {
            await getMoviesList(for: currentSearchText, reset: false)
        }
    }
    
    private func saveMoviesLocally(movieArray: [Movie]) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: "Movies",
            in: context
        ) else {
            debugPrint("Failed to get entity description")
            return
        }
        
        for movieData in movieArray {
            let existingMovies: [Movies] = persistence.fetchWithPredicate(Movies.self, key: "id", with: "\(movieData.id)")
            if existingMovies.isEmpty {
                let movies = Movies(entity: entity, insertInto: context)
                movies.id = Int64(movieData.id)
                movies.title = movieData.title
                movies.overview = movieData.overview
                movies.releaseDate = movieData.releaseDate
                movies.posterPath = movieData.posterPath
                movies.backdropPath = movieData.backdropPath
                movies.voteAverage = movieData.voteAverage
            }
        }
        
        persistence.save()
    }
    
    func getSavedMovies() {
        let savedMoviesArray = persistence.fetch(Movies.self)
        guard !savedMoviesArray.isEmpty else { return }
        
        movieData = savedMoviesArray.map { savedMoviesData in
            Movie(
                id: Int(savedMoviesData.id),
                title: savedMoviesData.title ?? "",
                overview: savedMoviesData.overview ?? "",
                releaseDate: savedMoviesData.releaseDate ?? "",
                posterPath: savedMoviesData.posterPath ?? "",
                backdropPath: savedMoviesData.backdropPath ?? "",
                voteAverage: savedMoviesData.voteAverage
            )
        }
    }
    
    func getFavoriteMoviesCount() {
        let savedFavorites: [FavoriteMovies] = persistence.fetch(FavoriteMovies.self)
        favoriteMoviesCount = savedFavorites.count
    }
}
