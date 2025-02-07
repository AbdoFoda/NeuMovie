//
//  MovieRow.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 07.02.25.
//

import SwiftUI
import NukeUI

struct MovieRow: View {
    let movie: Movie
    
    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: movie)) {
            HStack {
                LazyImage(url: movie.posterURL) { state in
                    if let image = state.image { image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 150)
                            .cornerRadius(10)
                    } else if state.error != nil {
                        Color.gray
                            .frame(width: 100, height: 150)
                            .overlay(Text("Failed"), alignment: .center)
                    } else {
                        ProgressView()
                            .frame(width: 100, height: 150)
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(movie.title)
                        .font(.headline)
                    Text(movie.overview)
                        .font(.subheadline)
                        .lineLimit(3)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
