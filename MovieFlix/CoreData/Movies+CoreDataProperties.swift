//
//  Movies+CoreDataProperties.swift
//  MovieFlix
//
//  Created by Sujal on 25/11/2025.
//
//

public import Foundation
public import CoreData


public typealias MoviesCoreDataPropertiesSet = NSSet

extension Movies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movies> {
        return NSFetchRequest<Movies>(entityName: "Movies")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var backdropPath: String?
    @NSManaged public var voteAverage: Double

}

extension Movies : Identifiable {

}
