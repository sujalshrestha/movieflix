//
//  SwiftUIView.swift
//  MovieFlix
//
//  Created by Sujal on 24/11/2025.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchText = ""
    @ObservedObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(viewModel.movieData, id: \.id) { name in
                    Text(name.title ?? "")
                }
                
                if viewModel.isLoading {
                    LoadingIndicatorView()
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search your favorite movies")
            .alert(AppConstants.appName, isPresented: $viewModel.onApiError.isError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.onApiError.message)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            viewModel.getMoviesList(for: "batman")
        }
    }
}

#Preview {
    SearchView()
}
