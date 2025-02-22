//
//  ContentView.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 29.01.25.
//

import SwiftUI

struct LatestMoviesView<ViewModel: LatestMoviesViewModelProtocol>: View {
    
    @ObservedObject var viewModel: ViewModel
    @State var selectedMovie: Movie?
    @State var isLoadingMore: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.moviesToDisplay.isEmpty && isLoadingMore{
                    ProgressView("Loading Movies...")
                        .font(.headline)
                        .padding()
                }
                // Search Bar
                TextField("Search movies...", text: $viewModel.searchQuery)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                List(viewModel.searchQuery.isEmpty ? viewModel.moviesToDisplay : viewModel.searchResults, id: \.id) { movie in
                    MovieRow(movie: movie)
                        .task {
                            if !isLoadingMore && movie === viewModel.moviesToDisplay.last {
                                isLoadingMore = true
                                viewModel.loadMoreMovies { _ in
                                    isLoadingMore = false
                                }
                            }
                        }
                }
                .navigationTitle("Now Playing")
                if isLoadingMore && !viewModel.moviesToDisplay.isEmpty {
                    ProgressView()
                }
            }
        }.task {
            if viewModel.moviesToDisplay.isEmpty && !isLoadingMore {
                self.isLoadingMore = true
                self.viewModel.loadMoreMovies() { error in
                    self.isLoadingMore = false
                }
            }
        }
    }
}


#Preview {
    LatestMoviesView(viewModel: LatestMoviesViewModel())
}
