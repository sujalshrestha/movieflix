//
//  SwiftUIView.swift
//  MovieFlix
//
//  Created by Sujal on 24/11/2025.
//

import SwiftUI
import Kingfisher

struct SearchView: View {
    
    @State private var searchText = ""
    @StateObject var viewModel = SearchViewModel()
    @State private var searchTask: Task<Void, Never>?
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.movieData.isEmpty && !viewModel.isLoading && !searchText.isEmpty {
                    EmptySearchView(
                        message: "No results found. Please search for your favorite movies."
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        if viewModel.movieData.isEmpty {
                            EmptySearchView(
                                message: "Search your favorite movies here. 🍿"
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            List(viewModel.movieData, id: \.id) { movie in
                                NavigationLink(destination: MovieDetailsView(movie: movie), label: {
                                    MovieCell(movie: movie)
                                }
                                )
                                .onAppear {
                                    viewModel.loadMoreIfNeeded(currentItem: movie)
                                }
                            }
                            .listStyle(.plain)
                        }
                    }
                }
                
                if viewModel.isLoading {
                    LoadingIndicatorView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                }
            }
            .navigationTitle("MovieFlix")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search your favorite movies")
            .alert(AppConstants.appName, isPresented: $viewModel.onApiError.isError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.onApiError.message)
            }
            .onChange(of: searchText) { oldValue, newValue in
                searchTask?.cancel()
                
                let trimmedValue = newValue.trimmingCharacters(in: .whitespaces)
                
                if trimmedValue.isEmpty {
                    return
                }
                
                searchTask = Task { [weak viewModel] in
                    try? await Task.sleep(nanoseconds: 500 * 1_000_000)
                    guard !Task.isCancelled else { return }
                    viewModel?.getMoviesList(for: trimmedValue, reset: true)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct MovieCell: View {
    
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 12) {
            if !movie.posterPath.isEmpty {
                let imageUrl = movie.posterPath
                KFImage(URL(string: AppConstants.getPosterImagePath(imageUrl: imageUrl)))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .frame(width: 80, height: 120)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 120)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.title3)
                
                Text("Release Date: \(movie.releaseDate)")
                    .font(.caption)
                
            }
        }
        
    }
}

#Preview {
    SearchView()
}
