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

    func execute<T: DataModel>(urlRequest: NetworkURLRequest, request: Request?, model: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        if let result = result as? Result<T, NetworkError> {
            completion(result)
        }
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
    
    func testGetMoviesListSuccess() {
        let expectation = self.expectation(description: "Fetch movies")
        
        let movie = Movie(id: 1, title: "Inception", overview: "", releaseDate: "", posterPath: "", backdropPath: "", voteAverage: 9.0)
        let response = MovieSearchResponse(page: 1, results: [movie], totalPages: 1, totalResults: 1)
        mockNetwork.result = .success(response)
        
        viewModel.getMoviesList(for: "Inception")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            XCTAssertEqual(self.viewModel.movieData.count, 1)
            XCTAssertEqual(self.viewModel.movieData.first?.title, "Inception")
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testGetMoviesListFailure() {
        let expectation = self.expectation(description: "API failure")
        
        mockNetwork.result = .failure(.serverError("Failed"))
        
        viewModel.getMoviesList(for: "Inception")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self else { return }
            XCTAssertEqual(self.viewModel.movieData.count, 0)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertTrue(self.viewModel.onApiError.isError)
            XCTAssertEqual(self.viewModel.onApiError.message, "Failed")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testLoadMoreIfNeeded() {
        let movie1 = Movie(id: 1, title: "Inception", overview: "", releaseDate: "", posterPath: "", backdropPath: "", voteAverage: 9.0)
        let movie2 = Movie(id: 2, title: "Tenet", overview: "", releaseDate: "", posterPath: "", backdropPath: "", voteAverage: 8.5)
        
        let response1 = MovieSearchResponse(page: 1, results: [movie1], totalPages: 2, totalResults: 2)
        let response2 = MovieSearchResponse(page: 2, results: [movie2], totalPages: 2, totalResults: 2)
        
        mockNetwork.result = .success(response1)
        viewModel.getMoviesList(for: "Movie")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.movieData.count, 1)
            
            self.mockNetwork.result = .success(response2)
            self.viewModel.loadMoreIfNeeded(currentItem: movie1)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self.viewModel.movieData.count, 2)
                XCTAssertEqual(self.viewModel.movieData.last?.title, "Tenet")
            }
        }
    }
    
    func testSearchReset() {
        viewModel.movieData = [
            Movie(id: 1, title: "Old Movie", overview: "", releaseDate: "", posterPath: "", backdropPath: "", voteAverage: 5.0)
        ]
        
        viewModel.getMoviesList(for: "New Movie")
        
        XCTAssertEqual(viewModel.movieData.count, 0)
        XCTAssertEqual(viewModel.currentPageValue, 1)
    }
    
    func makeInMemoryContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "MovieFlixModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
        
        return container.viewContext
    }
}
