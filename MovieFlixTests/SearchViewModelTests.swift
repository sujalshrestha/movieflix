//
//  SearchViewModelTests.swift
//  MovieFlixTests
//
//  Created by Sujal on 27/11/2025.
//

import XCTest
@testable import MovieFlix
internal import CoreData

class MockNetworkService: NetworkServiceProtocol {
    var result: Result<MovieSearchResponse, NetworkError>?

    func execute<T: DataModel>(urlRequest: NetworkURLRequest, request: Request?) async throws -> T {
        if let result = result as? Result<T, NetworkError> {
            return try result.get()
        }
        throw NetworkError.unknown
    }
}

class MockPersistenceManager: PersistenceProtocol {
    
    var movies: [Movie] = []
    
    func fetch<T>(_ object: T.Type) -> [T] where T : NSManagedObject {
        return []
    }
    
    func fetchWithPredicate<T>(_ object: T.Type, key: String, with value: String) -> [T] where T : NSManagedObject {
        return []
    }
    
    func save() {}
    
    func deleteAll() { movies.removeAll() }
    
    func delete(_ objectType: NSManagedObject) { }    
}

@MainActor
final class SearchViewModelTests: XCTestCase {
    
    var mockNetwork: MockNetworkService!
    var mockPersistence: MockPersistenceManager!
    var viewModel: SearchViewModel!
    
    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkService()
        mockPersistence = MockPersistenceManager()
        mockPersistence.movies.removeAll()
        viewModel = SearchViewModel(network: mockNetwork, persistence: mockPersistence)
    }
    
    override func tearDown() {
        mockNetwork = nil
        mockPersistence = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testGetMoviesListSuccess() async {
        let movie = Movie(id: 1, title: "Inception", overview: "", releaseDate: "", posterPath: "", backdropPath: "", voteAverage: 9.0)
        let response = MovieSearchResponse(page: 1, results: [movie], totalPages: 1, totalResults: 1)
        mockNetwork.result = .success(response)
        
        await viewModel.getMoviesList(for: "Inception")

        XCTAssertEqual(viewModel.movieData.count, 1)
        XCTAssertEqual(viewModel.movieData.first?.title, "Inception")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testGetMoviesListFailure() async {
        mockNetwork.result = .failure(.serverError("Failed"))
        
        await viewModel.getMoviesList(for: "Inception")

        XCTAssertEqual(viewModel.movieData.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.onApiError.isError)
        XCTAssertEqual(viewModel.onApiError.message, "Failed")
    }
    
    func testLoadMoreIfNeeded() async {
        let movie1 = Movie(id: 1, title: "Inception", overview: "", releaseDate: "", posterPath: "", backdropPath: "", voteAverage: 9.0)
        let movie2 = Movie(id: 2, title: "Tenet", overview: "", releaseDate: "", posterPath: "", backdropPath: "", voteAverage: 8.5)
        
        let response1 = MovieSearchResponse(page: 1, results: [movie1], totalPages: 2, totalResults: 2)
        let response2 = MovieSearchResponse(page: 2, results: [movie2], totalPages: 2, totalResults: 2)
        
        mockNetwork.result = .success(response1)
        await viewModel.getMoviesList(for: "Movie")
        XCTAssertEqual(viewModel.movieData.count, 1)

        mockNetwork.result = .success(response2)
        await viewModel.loadMoreIfNeeded(currentItem: movie1)

        XCTAssertEqual(viewModel.movieData.count, 2)
        XCTAssertEqual(viewModel.movieData.last?.title, "Tenet")
    }
    
    func testSearchReset() async {
        viewModel.movieData = [
            Movie(id: 1, title: "Old Movie", overview: "", releaseDate: "", posterPath: "", backdropPath: "", voteAverage: 5.0)
        ]
        
        await viewModel.getMoviesList(for: "New Movie")
        
        XCTAssertEqual(viewModel.movieData.count, 0)
        XCTAssertEqual(viewModel.currentPageValue, 1)
    }
}
