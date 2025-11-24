//
//  SearchViewModel.swift
//  MovieFlix
//
//  Created by Sujal on 24/11/2025.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var movieData: [Movie] = []
    @Published var onApiError: (isError: Bool, message: String) = (false, "")
    
    private var currentPage = 1
    private var totalPages = 1
    private var currentSearchText = ""
    
    func getMoviesList(for searchText: String, reset: Bool = true) {
        let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchText
        
        if reset { resetPageData(searchText: searchText) }
        
        guard currentPage <= totalPages else { return }
        
        let request = MovieRouter.searchMovie(query: encodedSearchText, page: currentPage)
        isLoading = true
        
        NetworkManager.shared.execute(urlRequest: request, model: MovieSearchResponse.self) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let response):
                self.movieData.append(contentsOf: response.results)
                self.currentPage += 1
                self.totalPages = response.totalPages
                
            case .failure(let error):
                print(error)
                self.onApiError = (true, error.localizedDescription)
            }
        }
    }
    
    private func resetPageData(searchText: String) {
        currentPage = 1
        totalPages = 1
        movieData = []
        currentSearchText = searchText
    }
    
    func loadMoreIfNeeded(currentItem item: Movie) {
        guard let last = movieData.last else { return }
        if last.id == item.id && currentPage <= totalPages && !isLoading {
            getMoviesList(for: currentSearchText, reset: false)
        }
    }
}
