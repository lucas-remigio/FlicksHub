//
//  DetailView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 10/10/2024.
//

import SwiftUI

struct DetailView: View {
    let imageUrl: String
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(height: 400)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 400)
                case .failure:
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 400)
                        .foregroundColor(.red)
                @unknown default:
                    Image(systemName: "questionmark")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 400)
                }
            }
            .padding()
        }
        .navigationTitle("Image Detail")
    }
}
