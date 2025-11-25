//
//  FavoriteMoviesView.swift
//  MovieFlix
//
//  Created by Sujal on 25/11/2025.
//

import SwiftUI

struct FavoriteMoviesView: View {
    
    @StateObject private var viewModel = FavoriteMoviesViewModel()
    
    var body: some View {
        Group {
            if viewModel.favoriteMoviesList.isEmpty {
                EmptySearchView(message: "No favorite movies yet. ❤️")
            } else {
                List(viewModel.favoriteMoviesList, id: \.id) { movie in
                    NavigationLink(
                        destination: MovieDetailsView(movie: movie),
                        label: {
                            MovieCell(movie: movie)
                        }
                    )
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.getMovieIsInFavorite()
        }
    }
}

#Preview {
    FavoriteMoviesView()
}
