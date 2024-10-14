//
//  FavoritesView.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 10/10/2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with back button and edit icon
            HStack {
                
                Text("Profile")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    // Action for edit button
                }) {
                    Image(systemName: "pencil")
                        .font(.title)
                        .padding()                        
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            
            // Profile Picture
            if let profilePictureURL = viewModel.profilePictureURL {
                AsyncImage(url: profilePictureURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()  // Show loading spinner while fetching the image
                            .frame(width: 250, height: 250)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                    case .failure:
                        // Display a placeholder if image fails to load
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .foregroundColor(.gray)
                    @unknown default:
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                // Placeholder image if no profile picture URL
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .foregroundColor(.gray)
            }
            
            // Username Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Username")
                    .foregroundColor(.gray)
                    .font(.headline)
                
                HStack {
                    Image(systemName: "person.fill")
                    Text(viewModel.displayName ?? "No username")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Stats placeholder
            Text("Stats")
                .foregroundColor(.gray)
                .font(.headline)
            
            Spacer()
            
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    ProfileView()
}
