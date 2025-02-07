//
//  MovieRow.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 07.02.25.
//

import SwiftUI

struct MovieRow: View {
    let movie: Movie

    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: movie)) {
            HStack {
                AsyncImage(url: movie.posterURL) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 120)
                .cornerRadius(8)
                
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
