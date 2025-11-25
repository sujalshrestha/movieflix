//
//  EmptySearchView.swift
//  MovieFlix
//
//  Created by Sujal on 24/11/2025.
//

import SwiftUI

struct EmptySearchView: View {
    
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.6))
            
            Text(message)
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptySearchView(message: "")
}
