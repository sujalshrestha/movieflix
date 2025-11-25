//
//  FavoriteMovies+CoreDataProperties.swift
//  MovieFlix
//
//  Created by Sujal on 25/11/2025.
//
//

public import Foundation
public import CoreData


public typealias FavoriteMoviesCoreDataPropertiesSet = NSSet

extension FavoriteMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovies> {
        return NSFetchRequest<FavoriteMovies>(entityName: "FavoriteMovies")
    }

    @NSManaged public var backdropPath: String?
    @NSManaged public var id: Int64
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double

}

extension FavoriteMovies : Identifiable {

}
