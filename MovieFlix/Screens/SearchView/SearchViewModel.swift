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
    
    func getMoviesList(for searchText: String) {
                
        let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchText
        let request = MovieRouter.searchMovie(query: encodedSearchText, page: 1)
        
        isLoading = true
        
        NetworkManager.shared.execute(urlRequest: request, model: MovieSearchResponse.self) { [weak self] result in
            guard let self = self else { return }
            isLoading = false
            
            switch result {
            case .success(let response):
                movieData = response.results
                
            case .failure(let error):
                print(error)
                onApiError = (true, error.localizedDescription)
            }
        }
        
        
    }
}
