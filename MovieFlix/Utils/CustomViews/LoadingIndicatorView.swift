//
//  LoadingIndicatorView.swift
//  MovieFlix
//
//  Created by Sujal on 24/11/2025.
//

import SwiftUI

struct LoadingIndicatorView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            
            ProgressView()
        }
        .transition(.opacity)
        .zIndex(1)
    }
}
