//
//  MovieDetailsView.swift
//  MovieFlix
//
//  Created by Sujal on 25/11/2025.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView: View {
    
    @StateObject private var viewModel = MovieDetailsViewModel()
    let movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                if !movie.backdropPath.isEmpty {
                    let imageUrl = movie.backdropPath
                    KFImage(URL(string: AppConstants.getBannerImagePath(imageUrl: imageUrl)))
                        .placeholder { ProgressView() }
                        .resizable()
                        .frame(height: 250)
                        .clipped()
                        .ignoresSafeArea(edges: .top)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 250)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    MovieCell(movie: movie)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.3))
                    
                    Text("Rating: \(String(format: "%.2f", movie.voteAverage))")
                        .font(.title3)
                    
                    Text("Overview")
                        .font(.title2)
                        .padding(.top, 8)
                    
                    Text(movie.overview)
                        .font(.body)
                }
                .padding(.horizontal, 8)
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.checkIfMovieIsInFavorite(movieData: movie)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        viewModel.addMovieToFavorite(movieData: movie)
                    }
                } label: {
                    Image(systemName: viewModel.isMovieFavorited ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isMovieFavorited ? .red : .white)
                }
                .accessibilityIdentifier("favoriteButton")
            }
        }
    }
}

#Preview {
    MovieDetailsView(
        movie: Movie(
            id: 1,
            title: "Batman",
            overview: "Bruce Wayne, haunted by the tragic loss of his parents as a child, dedicates his life to protecting Gotham City from the criminal forces that threaten to tear it apart. By day, he is a billionaire industrialist, philanthropist, and the heir to the Wayne family legacy. By night, he becomes the mysterious and feared vigilante known only as Batman. Operating from the shadows, Batman uses his unmatched intellect, advanced technology, and relentless physical training to fight corruption, crime, and injustice. As Gotham faces rising threats from powerful villains who seek chaos, he struggles not only with the criminals he battles but also with the emotional burden of leading a double life. He must decide how far he is willing to go to save the city he has sworn to protect, while constantly confronting the darkness within himself.",
            releaseDate: "2020-01-01",
            posterPath: "/cij4dd21v2Rk2YtUQbV5kW69WB2.jpg",
            backdropPath: "/rBN6GPKUDZ6ZKAQiEZegZ0DZb6V.jpg",
            voteAverage: 7.2)
    )
}
