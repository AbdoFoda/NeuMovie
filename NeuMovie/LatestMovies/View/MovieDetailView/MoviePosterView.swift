//
//  MoviePosterView.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 07.02.25.
//

import SwiftUI

struct MoviePosterView: View {
    let posterURL: URL?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: posterURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(height: 400)
            .clipped()

            // Gradient Overlay
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.8), Color.clear]),
                startPoint: .bottom,
                endPoint: .center
            )
            .frame(height: 150)
        }
    }
}

