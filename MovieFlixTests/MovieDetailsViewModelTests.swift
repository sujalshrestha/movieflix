//
//  MovieDetailsViewModelTests.swift
//  MovieFlixTests
//
//  Created by Sujal on 27/11/2025.
//

import XCTest
@testable import MovieFlix
internal import CoreData

class MockPersistenceManagerForMovieDetails: PersistenceProtocol {
    
    var favoriteMovies: [FavoriteMovies] = []
    var saveCallCount = 0
    var deleteCallCount = 0
    
    func fetch<T>(_ object: T.Type) -> [T] where T : NSManagedObject {
        if object == FavoriteMovies.self {
            return favoriteMovies as! [T]
        }
        return []
    }
    
    func fetchWithPredicate<T>(_ object: T.Type, key: String, with value: String) -> [T] where T : NSManagedObject {
        if object == FavoriteMovies.self {
            let val = Int64(value) ?? 0
            return favoriteMovies.filter { $0.id == val } as! [T]
        }
        return []
    }
    
    func save() {
        saveCallCount += 1
    }
    
    func deleteAll() {
        favoriteMovies.removeAll()
    }
    
    func delete(_ objectType: NSManagedObject) {
        deleteCallCount += 1
        if let movie = objectType as? FavoriteMovies {
            favoriteMovies.removeAll { $0.id == movie.id }
        }
    }
}

@MainActor
final class MovieDetailsViewModelTests: XCTestCase {
    
    var viewModel: MovieDetailsViewModel!
    var mockPersistence: MockPersistenceManagerForMovieDetails!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        // Create in-memory Core Data for testing
        let container = NSPersistentContainer(name: "MovieFlixModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
        
        mockContext = container.viewContext
        mockPersistence = MockPersistenceManagerForMovieDetails()
        mockPersistence.favoriteMovies.removeAll()
        
        viewModel = MovieDetailsViewModel(persistence: mockPersistence, context: mockContext)
    }
    
    override func tearDown() {
        viewModel = nil
        mockPersistence = nil
        mockContext = nil
        super.tearDown()
    }
    
    private func createMovie(id: Int, title: String) -> Movie {
        return Movie(
            id: id,
            title: title,
            overview: "Test overview",
            releaseDate: "2024-01-01",
            posterPath: "/poster.jpg",
            backdropPath: "/backdrop.jpg",
            voteAverage: 8.5
        )
    }
        
    func testAddMovieToFavorite_WhenNotFavorited_AddsMovieAndSetsFlag() {
        let movie = createMovie(id: 1, title: "Inception")
        
        XCTAssertFalse(viewModel.isMovieFavorited)
        XCTAssertTrue(mockPersistence.favoriteMovies.isEmpty)
        
        viewModel.addMovieToFavorite(movieData: movie)
        
        XCTAssertTrue(viewModel.isMovieFavorited)
        XCTAssertEqual(mockPersistence.saveCallCount, 1)
    }
}
