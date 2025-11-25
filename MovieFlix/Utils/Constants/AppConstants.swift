//
//  AppConstants.swift
//  MovieFlix
//
//  Created by Sujal on 24/11/2025.
//

import Foundation

struct AppConstants {
    static let appName = "MovieFlix"
    
    static func getPosterImagePath(imageUrl: String) -> String {
        return "https://image.tmdb.org/t/p/w154\(imageUrl)"
    }
    
    static func getBannerImagePath(imageUrl: String) -> String {
        return "https://image.tmdb.org/t/p/w500\(imageUrl)"
    }
}
