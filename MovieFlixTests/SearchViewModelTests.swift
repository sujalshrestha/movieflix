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
    
    @MainActor
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
    
    @MainActor
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
