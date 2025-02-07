//
//  ContentView.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 29.01.25.
//

import SwiftUI

struct LatestMoviesView<ViewModel: LatestMoviesViewModelProtocol>: View {
    
    @StateObject var viewModel: ViewModel
    @State var selectedMovie: Movie?
    @State var isLoadingMore: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.moviesToDisplay.isEmpty && isLoadingMore{
                    ProgressView("Loading Movies...")
                        .font(.headline)
                        .padding()
                }
                List(viewModel.moviesToDisplay) { movie in
                    MovieRow(movie: movie)
                        .onAppear() {
                            if movie === viewModel.moviesToDisplay.last {
                                isLoadingMore = true
                                viewModel.loadMoreMovies { _ in
                                    isLoadingMore = false
                                }
                            }
                        }
                }
                .navigationTitle("Now Playing")
                if isLoadingMore {
                    ProgressView()
                }
            }
        }.onAppear() {
            self.isLoadingMore = true
            self.viewModel.loadMoreMovies() { error in
                self.isLoadingMore = false
                if let error = error {
                    print("Error loading more movies: \(error)")
                }else {
                    print("All movies are loaded")
                    print(viewModel.moviesToDisplay.count)
                }
            }
        }
    }
}


#Preview {
    LatestMoviesView(viewModel: LatestMoviesViewModel())
}
